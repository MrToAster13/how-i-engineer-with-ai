#!/usr/bin/env bash
# Checks every tracked Markdown file for dead relative links, more than one
# em dash, and the AI-tell words that artifacts/writing-guidance.md bans.
# With --external it also requests every http(s) link and reports any that
# answer 400 or above, or not at all.
# Prints one line per finding and exits 1 when there is any.
#
#   .githooks/check-docs.sh [--external]

external=0
case "${1:-}" in
  "") ;;
  --external) external=1 ;;
  *) echo "usage: check-docs.sh [--external]" >&2; exit 2 ;;
esac

cd "$(git rev-parse --show-toplevel)" || exit 2
export LC_ALL=C

# The list on line 16 of artifacts/writing-guidance.md. That file is exempt
# because it names them.
banned='delve|leverage|robust|seamless|crucial|tapestry|testament|elevate|underscore|boasts|realm'
banned_exempt=artifacts/writing-guidance.md
em=$(printf '\342\200\224')
agent='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36'

fail=0
finding() { echo "$1"; fail=1; }

docs=$(mktemp) && links=$(mktemp) || exit 2   # links: url TAB file TAB line
trap 'rm -f "$docs" "$links"' EXIT
if ! git ls-files -z -- '*.md' > "$docs"; then
  echo "check-docs: git could not list the tracked files." >&2
  exit 2
fi

while IFS= read -r -d '' f; do
  p=./$f   # so a name that starts with "-" is not read as an option
  [ -f "$p" ] || continue   # tracked but deleted in the working tree
  dir=$(dirname "$p")

  # Relative links: [text](target), ![alt](target) and [label]: target.
  # A label that starts with "^" is a footnote, not a link.
  while IFS=: read -r n target; do
    case "$target" in http://*|https://*|mailto:*|\#*) continue ;; esac
    path=${target%%#*}
    [ -e "$dir/$path" ] || finding "$f:$n: dead relative link: $target"
  done < <(
    grep -noE '\]\([[:space:]]*[^)[:space:]]+' "$p" | sed 's/\]([[:space:]]*//'
    grep -noE '^ {0,3}\[[^]^][^]]*\]:[[:space:]]*[^[:space:]]+' "$p" |
      sed 's/^\([0-9]*\): \{0,3\}\[[^]]*\]:[[:space:]]*/\1:/'
  )

  ems=$(grep -n "$em" "$p" | cut -d: -f1)
  count=$(grep -o "$em" "$p" | wc -l | tr -d ' ')
  [ "$count" -gt 1 ] && finding "$f: $count em dashes, at most 1 allowed (lines $(echo $ems))"

  if [ "$f" != "$banned_exempt" ]; then
    while IFS=: read -r n word; do
      finding "$f:$n: banned word: $word"
    done < <(grep -noiwE "$banned" "$p")
  fi

  while IFS=: read -r n url; do
    # A bare URL picks up a sentence's full stop or the "**" of bold text.
    while case "$url" in *[.,\;:!?*]) true ;; *) false ;; esac; do url=${url%?}; done
    printf '%s\t%s\t%s\n' "$url" "$f" "$n" >> "$links"
  done < <(grep -noE 'https?://[^][()<>[:space:]"'"'"'`]+' "$p")
done < "$docs"

if [ "$external" -eq 1 ]; then
  while IFS= read -r url; do
    code=$(curl -s -o /dev/null -w '%{http_code}' -L --max-time 20 --retry 2 -A "$agent" "$url")
    case "$code" in
      [123][0-9][0-9]) continue ;;
    esac
    # 000 means no response: DNS failure, refused connection or timeout.
    while IFS=$'\t' read -r u f n; do
      [ "$u" = "$url" ] && finding "$f:$n: dead external link ($code): $url"
    done < "$links"
  done < <(cut -f1 "$links" | sort -u)
fi

exit "$fail"

#!/usr/bin/env bash
# Tests for .githooks/pre-commit and .githooks/check-docs.sh.
# Each test builds a throwaway repo under mktemp -d, runs the script inside it,
# and asserts on the exit code and on the file the output names.
# The --external tests need network access.
#
#   .githooks/tests/run.sh
set -u

hooks=$(cd "$(dirname "$0")/.." && pwd)
root=$(mktemp -d)
trap 'rm -rf "$root"' EXIT

# Keep the user's git config and hooks out of the fixture repos.
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1

# Fake tokens are built at runtime so no token-shaped literal lands in the repo.
# The argument is the length of the part after the prefix.
zeros() { printf "%0${1}d" 0; }
github_pat() { printf 'github_pat_a_%s' "$(zeros $(($1 - 2)))"; }
anthropic_key() { printf 'sk-ant-a-_%s' "$(zeros $(($1 - 3)))"; }
em=$(printf '\342\200\224')
dead_url=https://github.com/MrToAster13/mrtoaster13-plugins
live_url=https://github.com/MrToAster13/grc-fleet-scanner

# new_repo: make an empty repo and cd into it. Each test runs in a subshell.
new_repo() {
  cd "$(mktemp -d "$root/repo.XXXXXX")" || exit 1
  git -c init.defaultBranch=main init -q
  git config user.name test
  git config user.email test@example.invalid
}
# put <path> <content>: write a file, creating its folder.
put() { mkdir -p "$(dirname "$1")"; printf '%s\n' "$2" > "$1"; }
# stage_blob <path> <content>: stage a file without writing it to disk, for
# names the filesystem may refuse.
stage_blob() {
  git update-index --add --cacheinfo \
    "100644,$(printf '%s\n' "$2" | git hash-object -w --stdin),$1"
}
# utf16 <text>: print ASCII text as UTF-16LE with a byte order mark.
utf16() {
  local i
  printf '\377\376'
  for ((i = 0; i < ${#1}; i++)); do printf '%s\0' "${1:i:1}"; done
}
commit_all() { git add -A && git commit -qm fixture; }
# run <cmd...>: capture the combined output and the exit status.
run() { out=$("$@" 2>&1); status=$?; }
# blocked <file>: the run exited nonzero and its output names <file>.
blocked() {
  [ "$status" -ne 0 ] && printf '%s\n' "$out" | grep -qF -- "$1" && return 0
  echo "expected a nonzero exit naming '$1', got exit $status:"
  printf '%s\n' "$out"
  return 1
}
allowed() {
  [ "$status" -eq 0 ] && return 0
  echo "expected exit 0, got $status:"
  printf '%s\n' "$out"
  return 1
}
# errored: the run exited nonzero. A check that could not run must not pass.
errored() {
  [ "$status" -ne 0 ] && return 0
  echo "expected a nonzero exit, got 0:"
  printf '%s\n' "$out"
  return 1
}

# pre-commit, staged mode

test_hook_blocks_github_pat() {
  new_repo; put notes.txt "pat $(github_pat 20)"; git add -A
  run "$hooks/pre-commit"; blocked notes.txt
}
test_hook_allows_short_github_pat() {
  new_repo; put notes.txt "pat $(github_pat 19)"; git add -A
  run "$hooks/pre-commit"; allowed
}
test_hook_blocks_anthropic_key() {
  new_repo; put notes.txt "key $(anthropic_key 20)"; git add -A
  run "$hooks/pre-commit"; blocked notes.txt
}
test_hook_allows_short_anthropic_key() {
  new_repo; put notes.txt "key $(anthropic_key 19)"; git add -A
  run "$hooks/pre-commit"; allowed
}
test_hook_blocks_secret_in_name_with_space() {
  new_repo; put "my notes.md" 'api_key = "abcdef123456"'; git add -A
  run "$hooks/pre-commit"; blocked "my notes.md"
}
test_hook_allows_clean_name_with_space() {
  new_repo; put "my notes.md" "nothing secret here"; git add -A
  run "$hooks/pre-commit"; allowed
}
test_hook_blocks_api_key_assignment() {
  new_repo; put config.txt 'api_key = "abcdef123456"'; git add -A
  run "$hooks/pre-commit"; blocked config.txt
}
test_hook_allows_api_key_mention() {
  new_repo; put config.txt "Set the api_key in your shell profile."; git add -A
  run "$hooks/pre-commit"; allowed
}
test_hook_blocks_public_ip() {
  new_repo; put net.txt "resolver 8.8.8.8"; git add -A
  run "$hooks/pre-commit"; blocked net.txt
}
test_hook_allows_reserved_ips() {
  new_repo
  put net.txt "192.0.2.10 198.51.100.7 203.0.113.9 10.1.2.3 172.16.5.4 192.168.1.1 127.0.0.1"
  git add -A
  run "$hooks/pre-commit"; allowed
}
test_hook_skips_githooks_dir() {
  new_repo; put .githooks/sample 'api_key = "abcdef123456"'; git add -A
  run "$hooks/pre-commit"; allowed
}
test_hook_reads_name_like_index_stage() {
  # ":1:x" is git syntax for stage 1 of x.
  new_repo; stage_blob "1:1 notes.md" 'api_key = "abcdef123456"'
  run "$hooks/pre-commit"; blocked "1:1 notes.md"
}
test_hook_scans_utf16_text() {
  # Windows PowerShell 5.1 writes UTF-16LE with ">".
  new_repo; utf16 'api_key = "abcdef123456"' > notes.txt; git add -A
  run "$hooks/pre-commit"; blocked notes.txt
}
test_hook_scans_line_with_invalid_utf8() {
  # Windows-1252 smart quotes are not valid UTF-8.
  new_repo; printf 'password: \223hunter2secret\224\n' > creds.txt; git add -A
  run env LC_ALL=C.UTF-8 "$hooks/pre-commit"; blocked creds.txt
}
test_hook_scans_renamed_file() {
  new_repo; put a.txt "$(seq 1 40)"; commit_all
  git mv a.txt b.txt; printf 'api_key = "abcdef123456"\n' >> b.txt; git add -A
  run "$hooks/pre-commit"; blocked b.txt
}

# pre-commit --all

test_hook_all_blocks_tracked_secret() {
  new_repo; put config.txt 'api_key = "abcdef123456"'; commit_all
  run "$hooks/pre-commit" --all; blocked config.txt
}
test_hook_all_allows_clean_tracked_files() {
  new_repo; put README.md "clean"; put "my notes.md" "clean"; commit_all
  run "$hooks/pre-commit" --all; allowed
}
test_hook_all_scans_from_subdirectory() {
  new_repo; put config.txt 'api_key = "abcdef123456"'; put sub/a.txt "clean"; commit_all
  cd sub || return 1
  run "$hooks/pre-commit" --all; blocked config.txt
}
test_hook_all_fails_when_git_cannot_list() {
  new_repo; put config.txt 'api_key = "abcdef123456"'; commit_all
  printf 'garbage' > .git/index
  run "$hooks/pre-commit" --all; errored
}

# check-docs.sh

test_docs_blocks_dead_relative_link() {
  new_repo; put README.md "[x](missing.md)"; git add -A
  run "$hooks/check-docs.sh"; blocked README.md
}
test_docs_allows_live_relative_link() {
  new_repo
  put README.md "# top"
  put docs/b.md "b"
  put docs/a.md "[r](../README.md#top) [b](b.md) [d](./) [s](#local)"
  git add -A
  run "$hooks/check-docs.sh"; allowed
}
test_docs_blocks_two_em_dashes() {
  new_repo; put a.md "$(printf 'one %s two\nthree %s four' "$em" "$em")"; git add -A
  run "$hooks/check-docs.sh"; blocked a.md
}
test_docs_allows_one_em_dash() {
  new_repo; put a.md "one $em two"; git add -A
  run "$hooks/check-docs.sh"; allowed
}
test_docs_blocks_banned_word() {
  new_repo; put a.md "We Leverage the cache."; git add -A
  run "$hooks/check-docs.sh"; blocked a.md
}
test_docs_allows_banned_word_inside_longer_word() {
  new_repo; put a.md "Robustness is a goal."; git add -A
  run "$hooks/check-docs.sh"; allowed
}
test_docs_exempts_writing_guidance() {
  new_repo; put artifacts/writing-guidance.md "Avoid delve, leverage and robust."; git add -A
  run "$hooks/check-docs.sh"; allowed
}
test_docs_reads_name_with_space() {
  new_repo; put "my notes.md" "[x](missing.md)"; git add -A
  run "$hooks/check-docs.sh"; blocked "my notes.md"
}
test_docs_checks_only_tracked_files() {
  new_repo; put README.md "clean"; git add -A; put stray.md "[x](missing.md)"
  run "$hooks/check-docs.sh"; allowed
}
test_docs_checks_from_subdirectory() {
  new_repo; put README.md "[x](missing.md)"; put sub/a.md "clean"; git add -A
  cd sub || return 1
  run "$hooks/check-docs.sh"; blocked README.md
}
test_docs_reads_name_starting_with_dash() {
  new_repo; put ./-notes.md "[x](missing.md)"; git add -A
  run "$hooks/check-docs.sh"; blocked -notes.md
}
test_docs_fails_when_git_cannot_list() {
  new_repo; put README.md "[x](missing.md)"; commit_all
  printf 'garbage' > .git/index
  run "$hooks/check-docs.sh"; errored
}
test_docs_blocks_dead_reference_link() {
  new_repo; put a.md "$(printf 'See [the notes][n].\n\n[n]: docs/missing.md')"; git add -A
  run "$hooks/check-docs.sh"; blocked a.md
}
test_docs_allows_live_reference_link() {
  new_repo; put a.md "$(printf 'See [the readme][r].\n\n[r]: README.md "Title"')"
  put README.md "readme"; git add -A
  run "$hooks/check-docs.sh"; allowed
}
test_docs_allows_footnote_definition() {
  new_repo; put a.md "$(printf 'A claim.[^1]\n\n[^1]: Source text here.')"; git add -A
  run "$hooks/check-docs.sh"; allowed
}
test_docs_blocks_dead_link_with_spaced_target() {
  new_repo; put a.md "[x]( missing.md )"; git add -A
  run "$hooks/check-docs.sh"; blocked a.md
}
test_docs_skips_external_links_without_flag() {
  new_repo; put a.md "[p]($dead_url)"; git add -A
  run "$hooks/check-docs.sh"; allowed
}
test_docs_external_blocks_dead_url() {
  new_repo; put a.md "[p]($dead_url)"; git add -A
  run "$hooks/check-docs.sh" --external; blocked a.md
}
test_docs_external_allows_live_url() {
  new_repo; put a.md "[g]($live_url)"; git add -A
  run "$hooks/check-docs.sh" --external; allowed
}
test_docs_external_allows_bold_bare_url() {
  new_repo; put a.md "**$live_url**"; git add -A
  run "$hooks/check-docs.sh" --external; allowed
}

passed=0 failed=0
for t in $(declare -F | awk '{print $3}' | grep '^test_'); do
  if msg=$( ("$t") 2>&1 ); then
    passed=$((passed + 1)); echo "ok   $t"
  else
    failed=$((failed + 1)); echo "FAIL $t"; printf '%s\n' "$msg" | sed 's/^/     /'
  fi
done
echo "$passed passed, $failed failed"
[ "$failed" -eq 0 ]

# Repo checks

The scripts in this folder block leaked secrets, and they catch dead links and the writing patterns that [the writing guidance](../artifacts/writing-guidance.md) bans. They need bash, git, grep and curl, and nothing else.

## Turn on the pre-commit hook

Run this once in each clone:

```sh
git config core.hooksPath .githooks
```

From then on, `git commit` runs `.githooks/pre-commit` on the staged files. The hook blocks the commit when a file holds a private key, an AWS, GitHub, Slack or Anthropic token, a `key = value` secret, or a public IPv4 address outside the RFC 5737, RFC 1918 and loopback ranges. It skips files under `.githooks/`, because the hook defines the patterns itself. For a confirmed false positive, commit with `git commit --no-verify`.

## Run the checks by hand

| Command | What it checks |
| --- | --- |
| `.githooks/pre-commit --all` | Every tracked file, with the hook's rules. |
| `.githooks/check-docs.sh` | Every tracked `*.md` file. Each relative link must point at a file that exists, a file may hold one em dash at most, and no file may use a word from the banned list. `artifacts/writing-guidance.md` may name the banned words. |
| `.githooks/check-docs.sh --external` | The same, plus a request to every http(s) link. A status of 400 or above is a finding, and so is no answer within 20 seconds after 2 retries. |
| `.githooks/tests/run.sh` | The tests for the hook and the checker. The `--external` tests need network access. |

Each command names the file for every finding and exits nonzero when it finds anything.

## In CI

[`checks.yml`](../.github/workflows/checks.yml) runs the tests, `pre-commit --all` and `check-docs.sh --external` on every push to main and every pull request.

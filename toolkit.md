# The toolkit

These are the tools I drive. Most of them I did not write. I chose them, wired them together, and operate them. Credit goes where it's due, and being straight about that is the point.

| Tool | Who wrote it | What I use it for |
|------|--------------|-------------------|
| [Claude Code](https://www.anthropic.com/claude-code) | Anthropic | The agent runtime everything runs in. My pair for design, code, review, and docs. |
| [T3 Code](https://github.com/pingdotgg/t3code) | Ping.gg (MIT) | The app I run Claude Code sessions from. I use it to start parallel agent threads, each in its own checkout. |
| [pstack](https://github.com/cursor/plugins/tree/main/pstack) | Lauren Tan, in Cursor's plugin repo (MIT) | Agent workflow skills and principles. I use its `tdd` skill for what a good test is and its `unslop` skill for plain writing. |
| [`t3dotgg/tstack`](https://github.com/t3dotgg/tstack) | Theo Browne (MIT) | Agent skills for shipping and babysitting pull requests. I run copies unmodified, with my own overrides for which models review and a ban on force-push. |
| [`mattpocock/skills`](https://github.com/mattpocock/skills) | Matt Pocock (MIT) | I copy `grilling`, `grill-me`, `grill-with-docs`, and `domain-modeling` into my config. I use them to stress-test a plan one decision at a time before code starts. This repo was scoped in a grill-me session. |
| git guardrail hook | Started from [aihero.dev](https://www.aihero.dev/this-hook-stops-claude-code-running-dangerous-git-commands), now mostly mine | Blocks dangerous git commands before Claude can run them. **Modified by me:** I replaced the source's pattern match with a command parser. It blocks force-push whether the flag is long, short, clustered, abbreviated, or a `+refspec`, plus `git reset --hard`, `git clean -f`, `git branch -D`, and whole-tree checkouts, and it ignores the same words inside quoted text. |
| Steering-instruction files | Me | The rules that keep all of the above honest and on-spec. See [`artifacts/`](artifacts/). |

## Why list other people's tools on my own portfolio

Because operating a stack well is a real skill, and pretending I built the stack is not. A hiring manager can tell the difference in about one question. Knowing which tools to run, how to configure them, and where to put guardrails is what I'm claiming here, and it's true.

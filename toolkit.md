# The toolkit

These are the tools I drive. Most of them I did not write — I chose them, wired them together, and operate them. Credit goes where it's due, and being straight about that is the point.

| Tool | Who wrote it | What I use it for |
|------|--------------|-------------------|
| [Claude Code](https://www.anthropic.com/claude-code) | Anthropic | The agent harness everything runs in. My pair for design, code, review, and docs. |
| [`mattpocock/skills`](https://github.com/mattpocock/skills) | Matt Pocock | Installed skill collection. I use `grilling` to stress-test plans, `diagnosing-bugs` for hard bugs, `codebase-design` for module design, `tdd` and `review` for the test-and-review loop. |
| [`bradygaster/squad`](https://github.com/bradygaster/squad) | Brady Gaster (MIT) | Multi-agent coordination — casting, charters, ceremonies. I use it to run several agents on one build with clear roles. |
| git-guardrails hook | [aihero.dev](https://www.aihero.dev/this-hook-stops-claude-code-running-dangerous-git-commands) | Blocks dangerous git commands pre-commit. **Adapted by me:** dropped the `jq` dependency (not installed on my box), added a PowerShell matcher, reworded the block message. The dangerous-pattern list is the source's. |
| Steering-instruction files | Me | The rules that keep all of the above honest and on-spec. See [`artifacts/`](artifacts/). |

## Why list other people's tools on my own portfolio

Because operating a stack well is a real skill, and pretending I built the stack is not. A hiring manager can tell the difference in about one question. Knowing which tools to run, how to configure them, and where to put guardrails is what I'm actually claiming here — and it's true.

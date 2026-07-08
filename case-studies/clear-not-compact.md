# clear-not-compact — shipping an AI-workflow tool

A Claude Code plugin I built and published. Instead of `/compact`, which swaps a session's real history for a lossy summary you then keep working on top of, it runs a persist-then-clear loop: write the session state to disk, `/clear` to an empty context, and read it back on purpose.

Code: [`MrToAster13/clear-not-compact`](https://github.com/MrToAster13/clear-not-compact)

## What it is

Two Claude Code skills — `/handoff` (distill a session into a numbered doc) and `/resume` (read the latest one back) — packaged as an installable plugin (MIT): a `plugin.json` and marketplace manifest, a `CONTEXT.md` glossary, three ADRs, and a worked example handoff.

## What's actually mine

I'll be precise, because that's the point of this repo. The persist-then-clear **workflow** isn't my idea — it comes from a r/ClaudeCode thread, which the repo credits. What I did is turn that insight into a real, installable tool:

- Packaged it as a Claude Code plugin with a marketplace manifest, plus a standalone-install path.
- Wrote the design rationale as three ADRs: clear-and-resume over compaction; markdown as the canonical record with the GitHub issue optional; ship as both a plugin and standalone skills.
- Wrote the `CONTEXT.md` glossary and a worked example.

My contribution is the productization and the documentation, not inventing the pattern. I say that plainly rather than dress it up.

## Why it's here

It's a small piece, but it's a clear proof of the thesis behind this repo: I don't just *use* an AI workflow, I turn the good parts into tooling other people can install in one command — and I'm exact about which parts are mine and which I'm standing on.

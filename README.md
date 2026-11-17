# How I Engineer With AI

This repo demonstrates one competency: AI and agentic coding. It is a record of how I build with an AI pair: the workflow I run, the tools I drive on top of it, the skills I've built, and the discipline that keeps the output truthful. It isn't a claim that I invented an AI framework. It's the real work I ship with one.

A project earns a place here only if I built it with AI. The security and GRC depth those projects also prove lives on my résumé site. Here, each case study leads with *how* it was built, not what it does.

The flagship is a fleet compliance auditor I designed, built, and hardened with an AI pair. The other case studies are below.

## What's mine, and what I credit

A portfolio that blurs this line falls apart the first time someone asks a follow-up question. So I'll be exact.

**Mine:**
- The engineering in every case study. That covers the design, the threat model, the code that ships, and every decision I can defend in a room.
- The steering-instruction files that keep the AI on-spec and stop it writing slop. See [`artifacts/`](artifacts/).
- The choice of which tools to run, how to wire them together, and where to put guardrails.

**Not mine, and credited:**
- The skill and agent frameworks I run on top of Claude Code. I did not write these. I chose and operate them. The full list and its sources are in [`toolkit.md`](toolkit.md).
- Where a project started from someone else's code, I label it. The [WaveTrend Replay](case-studies/wavetrend-replay.md) case study is exactly that: the part of a fork I wrote, pulled into a clean repo of its own.

## Case studies

- **[GRC Fleet Auditor](case-studies/grc-fleet-auditor.md)** (flagship). A CIS compliance auditor for a fleet of Ubuntu hosts, built to never certify a host it didn't assess. It has a pytest suite gated in CI and a real security-hardening arc. Code: [`MrToAster13/grc-fleet-scanner`](https://github.com/MrToAster13/grc-fleet-scanner).
- **[WaveTrend Replay](case-studies/wavetrend-replay.md)**. A zero-dependency replay engine I built inside a fork of a trading bot, then extracted into a repo of my own. The case study leads with the fork instead of hiding it. Code: [`MrToAster13/wavetrend-replay`](https://github.com/MrToAster13/wavetrend-replay).
- **[elijah-zion.com portfolio site](case-studies/elijah-zion-portfolio.md)**. My personal site, built from scratch with an AI pair: an Astro static site on Cloudflare Pages. I wrote review workflows for it that run accessibility, responsive, and CSS-correctness passes in parallel, and I re-checked its honesty rules against the built `dist/`, not the source. It is listed for the build method, not the site's size. Live at [elijah-zion.com](https://elijah-zion.com). The repo is private.

## How I work

- **[Methodology](methodology.md)**. The loop I run with an AI pair, and the review discipline behind it.
- **[Skills](skills.md)**. The Claude Code skills I built or modified, each labeled by provenance with a note on what it proves.
- **[The toolkit](toolkit.md)**. Every tool I drive, who wrote it, and what I use it for.
- **[Artifacts](artifacts/)**. My actual steering-instruction files, the closest thing here to original prompt work.

## On AI co-authorship

All but 11 of the flagship project's non-merge commits carry a `Co-Authored-By: Claude` trailer. I left it there on purpose. I use Claude Code as a pair. It drafts, I direct and review, and nothing merges that I can't explain. If you want to test that, ask me why the auditor refuses to score a host below 50% confidence, or why a repeated rule result can never turn a failed check into a pass. I can walk you through both.

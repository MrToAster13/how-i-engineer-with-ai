# How I Engineer With AI

This repo demonstrates one competency: AI / agentic coding. It's an honest record of how I build with an AI pair — the workflow I run, the tools I drive on top of it, the skills I've built, and the discipline that keeps the output truthful. It isn't a claim that I invented an AI framework. It's the real work I ship with one.

A project earns a place here only if I genuinely built it with AI. The security and GRC depth those projects also prove lives on my résumé site; here, each case study leads with *how* it was built, not what it does.

The flagship is a fleet compliance auditor I designed, built, and hardened with an AI pair. The rest of the case studies are below.

## What's mine, and what I credit

A portfolio that blurs this line falls apart the first time someone asks a follow-up question. So I'll be exact.

**Mine:**
- The engineering in every case study — the design, the threat model, the code that ships, and every decision I can defend in a room.
- The steering-instruction files that keep the AI on-spec and stop it writing slop. See [`artifacts/`](artifacts/).
- The choice of which tools to run, how to wire them together, and where to put guardrails.

**Not mine, and credited:**
- The skill and agent frameworks I run on top of Claude Code. I did not write these. I chose and operate them. The full list and its sources are in [`toolkit.md`](toolkit.md).
- Where a project started from someone else's code, I label it. The [WaveTrend Replay](case-studies/wavetrend-replay.md) case study is exactly that: the part of a fork I actually wrote, pulled into a clean repo of its own.

## Case studies

- **[GRC Fleet Auditor](case-studies/grc-fleet-auditor.md)** (flagship) — a CIS compliance auditor for a fleet of Ubuntu hosts, built to never certify a host it didn't actually assess. 123 tests, CI, a real security-hardening arc. Code: [`MrToAster13/grc-fleet-scanner`](https://github.com/MrToAster13/grc-fleet-scanner).
- **[WaveTrend Replay](case-studies/wavetrend-replay.md)** — a zero-dependency backtesting engine I built inside a fork of a trading bot, then extracted into a repo that's 100% mine. The case study leads with the fork, not around it. Code: [`MrToAster13/wavetrend-replay`](https://github.com/MrToAster13/wavetrend-replay).
- **[clear-not-compact](case-studies/clear-not-compact.md)** — a Claude Code plugin I shipped: persist a session to disk and resume it, instead of `/compact`. Proof that I build the AI tooling I use, not just use it. Code: [`MrToAster13/mrtoaster13-plugins`](https://github.com/MrToAster13/mrtoaster13-plugins).
- **[elijah-zion.com portfolio site](case-studies/elijah-zion-portfolio.md)** — my personal site, built from scratch with an AI pair: an Astro static site on Cloudflare Pages, with custom review workflows I wrote for it — parallel accessibility, responsive, and CSS-correctness passes, each finding adversarially verified against the built `dist/`, not the source. Listed for the build method, not the site's size. Live at [elijah-zion.com](https://elijah-zion.com); the repo is private.

## How I work

- **[Methodology](methodology.md)** — the loop I run with an AI pair, and the review discipline behind it.
- **[Skills](skills.md)** — the Claude Code skill artifacts I built or modified, each labeled by provenance and with a note on what it proves.
- **[The toolkit](toolkit.md)** — every tool I drive, who wrote it, and what I use it for.
- **[Artifacts](artifacts/)** — my actual steering-instruction files, the closest thing here to original prompt work.

## On AI co-authorship

Every commit in the flagship project carries a `Co-Authored-By: Claude` trailer. I left it there on purpose. I use Claude Code as a pair: it drafts, I direct and review, and nothing merges that I can't explain. If you want to test that, ask me why the auditor refuses to score a host below 50% confidence, or why the CIS-to-NIST crosswalk is labeled non-authoritative. I can walk you through both.

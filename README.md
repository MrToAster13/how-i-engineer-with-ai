# How I Engineer With AI

I'm a security engineer. This repo is an honest record of how I build with AI: the workflow I run, the tools I drive on top of it, and the discipline that keeps the output truthful. It isn't a claim that I invented an AI framework. It's the real work I ship with one. Most of it is security; some of it isn't, and I'm clear about which is which.

The flagship is a fleet compliance auditor I designed, built, and hardened with an AI pair. The rest of the case studies are below.

## What's mine, and what I integrate

A portfolio that blurs this line falls apart the first time someone asks a follow-up question. So I'll be exact.

**Mine:**
- The engineering in every case study — the design, the threat model, the code that ships, and every decision I can defend in a room.
- The steering-instruction files that keep the AI on-spec and stop it writing slop. See [`artifacts/`](artifacts/).
- The choice of which tools to run, how to wire them together, and where to put guardrails.

**Integrated, with credit:**
- The skill and agent frameworks I run on top of Claude Code. I did not write these. I chose and operate them. The full list and its sources are in [`toolkit.md`](toolkit.md).
- Where a project started from someone else's code, I label it. The [Market Cipher Replay](case-studies/market-cipher-replay.md) case study is exactly that: the part of a fork I actually wrote, pulled into a clean repo of its own.

## Case studies

- **[GRC Fleet Auditor](case-studies/grc-fleet-auditor.md)** (flagship) — a CIS compliance auditor for a fleet of Ubuntu hosts, built to never certify a host it didn't actually assess. 123 tests, CI, a real security-hardening arc. Code: [`MrToAster13/grc-fleet-scanner`](https://github.com/MrToAster13/grc-fleet-scanner).
- **[Market Cipher Replay](case-studies/market-cipher-replay.md)** — a zero-dependency backtesting engine I built inside a fork of a trading bot, then extracted into a repo that's 100% mine. The case study leads with the fork, not around it. Code: [`MrToAster13/market-cipher-replay`](https://github.com/MrToAster13/market-cipher-replay).
- **[clear-not-compact](case-studies/clear-not-compact.md)** — a Claude Code plugin I shipped: persist a session to disk and resume it, instead of `/compact`. Proof that I build the AI tooling I use, not just use it. Code: [`MrToAster13/clear-not-compact`](https://github.com/MrToAster13/clear-not-compact).
- **[Detection Engineering Homelab](https://github.com/MrToAster13/detection-engineering-homelab)** — an Elastic SOC lab with detection rules written against real internet attack traffic, including a triage that proved a successful root login during a brute-force wave was a benign admin, not a breach.

## How I work

- **[Methodology](methodology.md)** — the loop I run with an AI pair, and the review discipline behind it.
- **[The toolkit](toolkit.md)** — every tool I drive, who wrote it, and what I use it for.
- **[Artifacts](artifacts/)** — my actual steering-instruction files, the closest thing here to original prompt work.

## On AI co-authorship

Every commit in the flagship project carries a `Co-Authored-By: Claude` trailer. I left it there on purpose. I use Claude Code as a pair: it drafts, I direct and review, and nothing merges that I can't explain. If you want to test that, ask me why the auditor refuses to score a host below 50% confidence, or why the CIS-to-NIST crosswalk is labeled non-authoritative. I can walk you through both.


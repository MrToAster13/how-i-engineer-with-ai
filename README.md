# How I Engineer With AI

I'm a security engineer. This repo shows how I build: the AI-assisted workflow I run, the tools I drive on top of it, and the discipline that keeps the output honest. It isn't a claim that I invented an AI framework. It's a record of how I use one to ship real security work.

The proof is a real project — a fleet compliance auditor I designed, built, and hardened with an AI pair. It's the flagship case study below.

## What's mine, and what I integrate

A portfolio that blurs this line falls apart the first time someone asks a follow-up question. So I'll be exact.

**Mine:**
- The security engineering — the design, the threat model, the code that ships, and every decision I can defend in a room.
- The steering-instruction files that keep the AI on-spec and stop it writing slop. See [`artifacts/`](artifacts/).
- The choice of which tools to run, how to wire them together, and where to put guardrails.

**Integrated, with credit:**
- The skill and agent frameworks I run on top of Claude Code. I did not write these. I chose and operate them. The full list and its sources are in [`toolkit.md`](toolkit.md).

## Start here

- **[Flagship case study: GRC Fleet Auditor](case-studies/grc-fleet-auditor.md)** — a CIS compliance auditor for a fleet of Linux hosts, built to never certify a host it didn't actually assess. Code: [`MrToAster13/grc-fleet-scanner`](https://github.com/MrToAster13/grc-fleet-scanner).
- **[How I work](methodology.md)** — the loop I run with an AI pair, and the review discipline behind it.
- **[The toolkit](toolkit.md)** — every tool I drive, who wrote it, and what I use it for.
- **[Artifacts](artifacts/)** — my actual steering-instruction files, the closest thing here to original prompt work.

## On AI co-authorship

Every commit in the flagship project carries a `Co-Authored-By: Claude` trailer. I left it there on purpose. I use Claude Code as a pair: it drafts, I direct and review, and nothing merges that I can't explain. If you want to test that, ask me why the auditor refuses to score a host below 50% confidence, or why the CIS-to-NIST crosswalk is labeled non-authoritative. I can walk you through both.

## More security work

- [`detection-engineering-homelab`](https://github.com/MrToAster13/detection-engineering-homelab) — an Elastic SOC lab with detection rules written against real internet attack traffic, including a triage that proved a successful root login during a brute-force wave was a benign admin, not a breach.

# Artifacts

These are the instruction files I write to steer AI agents. They're the closest thing in this repo to original prompt work — I wrote them, and they're what keeps AI output plain, honest, and on-spec.

## Files

- [`writing-guidance.md`](writing-guidance.md) — the guidance file I drop at the top of my repos. It bans AI-tell words, forces varied sentence rhythm, and sets hard honesty rules ("only document what is real and verifiable"). Every doc in this repo follows it. The [GRC auditor](../case-studies/grc-fleet-auditor.md) has a commit titled `docs: replace vague adjectives per AGENTS.md` that this file drove.

## The pattern

Beyond the writing rules, I write per-project briefs that pin down constraints before code starts — the stack, what's in and out of scope, and integrity rules specific to the work. My portfolio-site brief, for example, carries an honesty rule (list only certifications I actually hold) and OPSEC rules (sanitize any real IPs to RFC-5737 ranges before anything is committed). The brief isn't published here because it holds personal detail, but the discipline is the same one on display in [`writing-guidance.md`](writing-guidance.md): tell the agent the truth-conditions up front, and it stays honest.

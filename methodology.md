# How I work

The short version: I use Claude Code as a pair, not as an author. It drafts fast; I direct, review, and own the result. Nothing merges that I can't explain.

Here's the loop I actually run, drawn from how the [GRC auditor](case-studies/grc-fleet-auditor.md) got built.

## 1. Grill the plan before writing code

Before a build starts, I stress-test the plan — one decision at a time, resolving dependencies in order. Cutting a bad design decision early is a lot cheaper than refactoring around it later. This repo itself was scoped that way.

## 2. Build a walking skeleton first

Get the thinnest end-to-end version working before adding depth. For the auditor that meant one host, one check, one report — proving the pipeline holds together before hardening any single stage.

## 3. Fan out, with clear ownership

Once the skeleton stands, I split hardening across parallel agents, each with exclusive ownership of a module so they don't collide. The auditor's changelog records five agents hardening distinct modules this way. It's faster, and file-level ownership keeps the diffs clean.

## 4. Review on every pass

This is the gate that keeps AI output from turning into slop.

- Every change gets a `/code-review` pass; a `/simplify` pass strips the cruft.
- Commits stay small and conventional (`feat:`, `fix:`, `security(phase N):`), one logical change each.
- Tests run before anything merges. The auditor ships 123 of them.

## 5. Steer with instruction files

I put an `AGENTS.md` or `CLAUDE.md` at the top of a repo to set the rules the AI has to follow — plain prose, no filler, honest reporting, no invented facts. It works: one auditor commit is literally titled `docs: replace vague adjectives per AGENTS.md`. My actual instruction files are in [`artifacts/`](artifacts/).

## 6. Guardrails against the obvious mistakes

- A guardrail hook blocks dangerous git commands (force-push, hard reset, and friends) before Claude can run them.
- A permission allowlist scopes what the agent can do without asking.
- Honesty rules in the instruction files: never claim work that isn't built, never fabricate a result.

## What this gets me

Speed without the usual cost. The AI handles the volume; the review discipline and the guardrails keep the output correct, honest, and readable. When someone asks why a design went the way it did, the answer is mine — because I made the call, not the model.

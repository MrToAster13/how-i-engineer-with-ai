# How I work

The short version: I use Claude Code as a pair, not as an author. It drafts fast. I direct, review, and own the result. Nothing merges that I can't explain.

Here's the loop I run, drawn from how the [GRC auditor](case-studies/grc-fleet-auditor.md) got built and from how I work today.

## 1. Grill the plan before writing code

Before a build starts, I stress-test the plan one decision at a time, resolving dependencies in order. Cutting a bad design decision early is a lot cheaper than refactoring around it later. This repo itself was scoped that way.

## 2. Build a walking skeleton first

Get the thinnest end-to-end version working before adding depth. For the auditor that meant one host run through the full pipeline, from discovery to report. It proved the pipeline held together before I hardened any single stage.

## 3. Fan out, with clear ownership

Once the skeleton stands, I split hardening across parallel agents. Each gets exclusive ownership of a module so they don't collide. On the auditor, five agents hardened distinct modules this way. It's faster, and file-level ownership keeps the diffs clean. Today each agent also works in its own checkout, so no two agents share a working tree.

## 4. Test first, then review on every pass

This is the gate that keeps AI output from turning into slop.

- Every code change starts with failing tests written from the acceptance criteria. The implementation gets at most ten logged attempts to turn them green. If it stalls, the work stops uncommitted and comes back to me.
- A second agent then reviews the green change adversarially. Its job is to break the code, and each finding it confirms gets a failing regression test before the fix.
- A secrets scan runs before every commit. On the auditor, commit messages cite `/code-review` and `/simplify` passes.
- Commits stay small, one logical change each.
- Tests run before anything merges. The auditor's pytest suite runs in CI on every push to main and every pull request.

## 5. Steer with instruction files

I put an `AGENTS.md` or `CLAUDE.md` at the top of a repo to set the rules the AI has to follow: plain prose, no filler, honest reporting, no invented facts. It works. One auditor commit is titled `docs: replace vague adjectives per AGENTS.md`. My actual instruction files are in [`artifacts/`](artifacts/).

## 6. Guardrails against the obvious mistakes

- A guardrail hook blocks dangerous git commands before Claude can run them: force-push, hard reset, and friends.
- A permission allowlist scopes what the agent can do without asking.
- Honesty rules in the instruction files: never claim work that isn't built, and never fabricate a result.
- This repo checks itself. CI fails on a dead link, a leaked secret, or a doc that breaks its own writing rules.

## What this gets me

Speed without the usual cost. The AI handles the volume. Tests, review, and guardrails keep it correct. When someone asks why a design went the way it did, the answer is mine, because I made the call, not the model.

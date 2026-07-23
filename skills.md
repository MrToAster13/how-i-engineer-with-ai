# Skills

These are the Claude Code skill artifacts I built or modified. They're the sharpest evidence in this repo for the one competency it demonstrates — AI / agentic coding — because they show the method itself, not a domain outcome. Read each one for the discipline it encodes: gather before you judge, design against your own bias, turn real work into verifiable evidence.

Provenance labels are load-bearing here. Built means my own design and code from scratch; Modified means I started from someone else's skill and credit them, and their license ships with it. The definitions live in [`CONTEXT.md`](CONTEXT.md). Where a skill bundles a script or a harness, I describe what the design does — not results I'm claiming to have produced.

**Provenance at a glance:** 9 Built, 2 Modified.

## Analysis systems

### code-audit-agent

A code-change auditor built on a gather-first-then-judge rule: it reads all the context — the diff, the full files, adjacent importers, the tests — before forming any judgment. Only then does it run a three-persona council (Correctness, Architecture, and an AI-Hallucination Detector), and its design emits severity-ranked findings with ready-to-paste fix prompts.

**What it proves:** verification discipline. Refusing to judge on partial information is the reviewer's core habit, and this skill makes it mechanical.

**Provenance:** Built.

The next three skills are one engine in three forms — a five-team adversarial research architecture, pointed at different problems.

### general-intel-agent-on-roids

A five-team research engine. The teams (Primary, Institutional, Outcomes, Comparative, Adversarial) run blind to each other and to any target score, a blind-retry loop pushes for a better pass ("You did not reach the standard. Do significantly better."), and the run ends by declaring a ceiling rather than a single confident number.

**What it proves:** designing against my own bias, with disconfirmation built into the structure instead of bolted on.

**Provenance:** Built.

### research-agent

The same council idea rendered as an intelligence briefing in the President's-Daily-Brief style: an orchestrator plus a three-persona council (Domain Expert, Methods Analyst, Contrarian), key intelligence questions, tiered sourcing from T1 to T4, confidence calibration, and a dedicated Dissenting Analysis section.

**What it proves:** generalizing one architecture across problems, and holding a sourcing standard while doing it.

**Provenance:** Built.

### cyber-cert-intel-agent

The five-team council aimed at evaluating cybersecurity certifications. It scores Knowledge, Recognition, and Certainty against a rubric that separates causal signal from mere correlation.

**What it proves:** the same engine again, this time carrying into the security domain.

**Provenance:** Built.

### evidence-builder

Turns real homelab artifacts — configs, logs, topology — into a push-ready repo with a README, an architecture diagram, a blog draft, and a `resource_bank.yaml` entry. Its iron rule is real artifacts only, never a topic on its own; the blog always gets my edit pass; secrets get scrubbed; and the honesty carries through into the bank entry.

**What it proves:** systematizing the move from real work to verifiable evidence — the same discipline this whole portfolio runs on.

**Provenance:** Built.

### skill-creator-v2

Starts from Anthropic's `skill-creator` example and adds two things of my own: a self-healing agent, and a variance-aware eval harness whose design measures a skill's trigger accuracy across a train/test split with three runs per query.

**What it proves:** I can extend someone else's framework and add real instrumentation on top, not just consume it.

**Provenance:** Modified — extends Anthropic's `skill-creator` example, and their license ships with it.

## Workflow tooling

### grill-me

Interviews a plan one decision at a time, walking the dependency tree, committing to a recommended answer at each step, and exploring the codebase instead of asking when it can find the answer itself. This repo was scoped in a grill-me session.

**What it proves:** stress-testing decisions before any code gets written.

**Provenance:** Built.

This one is also a Workflow — the grill-first practice it packages is described in [`methodology.md`](methodology.md), so it's cross-listed there.

### video-learn

Chains ffmpeg frame extraction, Whisper transcription, and batched vision description into a single timestamped guide. Its design runs the heavy steps in disposable sub-contexts so the raw frames never flood the main context.

**What it proves:** chaining real tools into a working pipeline and keeping the context budget under control.

**Provenance:** Modified — its own SKILL.md calls it a synthesis of three community skills: `fabriqaai/ffmpeg-analyse-video-skill`, `ItachiDevv/claude-video-analyzer`, and `msadig/video-input` (MIT). I don't present it as original work.

### resume-tailor

Generates an ATS-safe resume from a job posting, drawing only on a private, honesty-gated `resource_bank.yaml`. Every bullet traces back to a real atom, the `honesty_notes` are inviolable, a review gate is mandatory before anything renders, and it outputs both `.docx` and plain text.

**What it proves:** even my job-search tooling enforces honesty by design. The committed `resume_spec.example.yaml` is a fictional sample; the real bank stays private.

**Provenance:** Built.

### weak-topic-logger

A small formatter that turns missed practice-exam questions into tab-separated rows for a study log.

**What it proves:** modestly, the automate-the-boring-parts habit.

**Provenance:** Built. I'll be straight about this one: it's light, and it's the easiest thing here to cut.

### pre-push

One orchestrator for the pre-push ritual. It detects whether the repo is Python or Node, picks the matching lint/format/test tooling, then runs simplify → review → security → test → commit as gated stages. It stops only on a genuine failure: flaky network during a test run gets retried three times first, and it flips non-executable shell scripts to mode `100755` so they don't land broken on a Linux install. The runnable skill ships in [`mrtoaster13-plugins`](https://github.com/MrToAster13/mrtoaster13-plugins/tree/main/plugins/autonomous-workflows/skills/pre-push).

**What it proves:** turning a manual release checklist into a deterministic pipeline, with the judgment calls — what's a real failure versus noise — encoded in the gates instead of left to the moment.

**Provenance:** Built.

## Also shipped

`clear-not-compact` is a skill too — a `/handoff` and `/resume` pair, packaged as an installable Claude Code plugin, that replaces `/compact` with a persist-then-clear loop. It has its own case study: [clear-not-compact](case-studies/clear-not-compact.md).

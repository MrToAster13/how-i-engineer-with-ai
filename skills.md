# Skills

These are the Claude Code skills I built or modified. They're the sharpest evidence in this repo for AI and agentic coding, because they show the method itself, not a domain outcome. Read each one for the discipline it encodes: gather before you judge, hold a sourcing standard, keep job-search tooling honest.

The skill files are not published. Each entry describes the design, and I can walk through any of them. Where a skill bundles a script or a harness, I describe what the design does, not results I'm claiming to have produced.

Provenance labels matter here. Built means my own design and code from scratch. Modified means I started from someone else's skill and credit them by name. The definitions live in [`CONTEXT.md`](CONTEXT.md). Skills I run but did not write, such as Matt Pocock's `grill-me`, are in [`toolkit.md`](toolkit.md).

**Provenance at a glance:** 4 Built, 2 Modified.

## Analysis systems

### code-audit-agent

A code-change auditor built on a gather-first-then-judge rule. It reads all the context before forming any judgment: the diff, the full files, adjacent importers, the tests. Only then does it run a three-persona council (Correctness, Architecture, and an AI-Hallucination Detector), and its design emits severity-ranked findings with ready-to-paste fix prompts.

**What it proves:** verification discipline. Refusing to judge on partial information is the reviewer's core habit, and this skill makes it mechanical.

**Provenance:** Built.

### research-agent

A council rendered as an intelligence briefing in the President's-Daily-Brief style. An orchestrator runs a three-persona council (Domain Expert, Methods Analyst, Contrarian) over key intelligence questions, with tiered sourcing from T1 to T4, confidence calibration, and a dedicated Dissenting Analysis section.

**What it proves:** holding a sourcing standard, with dissent built into the structure instead of bolted on.

**Provenance:** Built.

### skill-creator-v2

Starts from Anthropic's `skill-creator`, which already ships a train/test eval harness with three runs per query. I added one thing: a self-healing agent that proposes add, simplify, and fix edits to a skill after each session and writes nothing until I approve.

**What it proves:** I can extend someone else's framework without breaking what it already does, and keep a human gate on self-modifying code.

**Provenance:** Modified. It extends Anthropic's `skill-creator`, and the credit ships with it.

## Workflow tooling

### video-learn

Chains ffmpeg frame extraction, Whisper transcription, and batched vision description into a single timestamped guide. Its design runs the heavy steps in disposable sub-contexts so the raw frames never flood the main context.

**What it proves:** chaining real tools into a working pipeline and keeping the context budget under control.

**Provenance:** Modified. Its own SKILL.md calls it a synthesis of three community skills: `fabriqaai/ffmpeg-analyse-video-skill`, `ItachiDevv/claude-video-analyzer` (MIT), and `msadig/video-input`. I don't present it as original work.

### resume-tailor

Generates an ATS-safe resume from a job posting, drawing only on a private, honesty-gated `resource_bank.yaml`. Every bullet traces back to a real atom, and the `honesty_notes` are inviolable. A review gate is mandatory before anything renders, and it outputs both `.docx` and plain text.

**What it proves:** even my job-search tooling enforces honesty by design. The real bank stays private.

**Provenance:** Built.

### weak-topic-logger

A small formatter that turns missed practice-exam questions into tab-separated rows for a study log.

**What it proves:** modestly, the automate-the-boring-parts habit.

**Provenance:** Built. I'll be straight about this one: it's light, and it's the easiest thing here to cut.

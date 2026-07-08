# How I Engineer With AI

The domain model for this repo. Its single purpose is to demonstrate one competency —
AI / agentic coding — through the projects Elijah built and the skills and workflows he
uses. This file is the glossary that keeps that language precise; it holds no
implementation detail.

## Language

### What is demonstrated

**Competency**:
A professional ability the portfolio demonstrates. This repo demonstrates exactly one —
AI / agentic coding. A résumé site may lead with several (detection engineering, GRC).
_Avoid_: skill (reserved below), capability, strength.

### How it is demonstrated

Competency is shown two ways: through **Projects**, and through the **Skills** and
**Workflows** used to build them.

**Project**:
A thing Elijah built that serves as evidence of a competency. The same Project can
evidence a different competency in a different place — the GRC auditor is "GRC" on the
résumé site but "AI / agentic coding" here, viewed through *how* it was built.
_Avoid_: app.

**Case study**:
The written account of a Project — what it is, how it was built with AI, and what it
proves. Lives in this repo.
_Avoid_: writeup (that is the résumé site's term for a security write-up), post.

**Skill**:
A Claude Code skill artifact — an installable unit with its own files. Distinct from a
Competency and never a synonym for one. A Skill carries a provenance (see below).
_Avoid_: capability, competency.

**Workflow**:
A repeatable way of working with AI — a method or practice, e.g. grill-first design,
adversarial verification, persist/resume. A Skill may package a Workflow.
_Avoid_: process, technique.

### Provenance

Every Skill or Project carries exactly one provenance label. The label tracks the
work's *origin*; a narrative note carries any nuance.

**Built**:
Of my own design and code, written from scratch. The underlying idea may be public and
is credited when it is.
_Avoid_: original, from-scratch.

**Modified**:
Began from someone else's code — whether I extended it (`skill-creator-v2` adds an eval
harness to Anthropic's `skill-creator`) or extracted and rewrote it (`wavetrend-replay`,
pulled out of a fork). Their license or credit ships with it.
_Avoid_: adapted, forked, extracted.

**Driven**:
Someone else's artifact that I operate unmodified — not mine (Matt Pocock's skills,
Squad, the Claude Code built-ins).
_Avoid_: used, integrated.

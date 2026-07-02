# GRC Fleet Auditor

A Python CLI that audits a fleet of Ubuntu hosts against the CIS Benchmark and produces audit-defensible compliance evidence. I designed it, built it with an AI pair, and hardened it across four security passes.

Code: [`MrToAster13/grc-fleet-scanner`](https://github.com/MrToAster13/grc-fleet-scanner)

## The problem

A GRC analyst needs to answer one question about a fleet of servers: which hosts meet the benchmark, and where's the proof? The proof matters as much as the answer. An auditor won't accept "trust me" — they want evidence they can trace back to an authoritative source.

The trap is a tool that reports a clean pass when it didn't really check. A host that was unreachable, or missing the scanner, or scanned only partially, cannot be called compliant. Calling it compliant anyway is how a bad audit gets signed.

## What I built

The tool wraps OpenSCAP and the SCAP Security Guide rather than reimplementing compliance checks. That's a deliberate call: verdicts come from the authoritative scanner, so they hold up in an audit. My work is the orchestration around it.

The pipeline:

```
discover (nmap) → classify → reach (SSH) → detect (oscap/SSG) → scan (oscap)
  → persist (SQLite) → report (HTML/JSON/CSV + run-over-run drift)
```

About 2,700 lines of Python across the package. Each run writes to `grc-output/runs/<run_id>/` with the HTML report, machine-readable JSON/CSV, an audit log, the effective config, the raw OpenSCAP evidence per host, and a `manifest.json` holding SHA-256 digests of every artifact — so a reviewer can confirm nothing was edited after the fact.

## The decision I'm proudest of: never a false pass

Every host lands in exactly one honest coverage bucket: `scanned`, `non_ubuntu`, `no_credentials`, `unreachable`, `scanner_absent`, `unsupported_version`, `host_key_mismatch`, or `scan_error`. Partial coverage is never dressed up as a clean result.

Two mechanisms enforce it:

- A single chokepoint, `finalize_scan_status`, gates the `scanned` verdict. Nothing else can mark a host compliant.
- A hard confidence floor. A scan that assessed less than 50% of the applicable rules becomes `scan_error`, not a pass — and that floor can't be overridden by config.

I also had to re-derive the confidence denominator so that rules outside the selected profile couldn't inflate or tank the score. That fix is documented in the changelog.

The point: the tool would rather under-report than certify a host it didn't really assess. That's the judgment a GRC role is actually hiring for.

## Security hardening

The scanner runs commands on remote hosts over SSH, so it's a real attack surface. I worked through it in phases:

- **Remote command injection** — a malicious host could return a crafted `mktemp` path that reached a `sudo` command. Fixed, with a regression test (`test_malicious_mktemp_output_is_refused`) that feeds a shell-injection payload and asserts it's refused.
- **Stored XSS and CSV injection** in the generated reports — fixed, since reports get opened in browsers and spreadsheets.
- **XML parsing** hardened with `defusedxml` against entity-expansion attacks on scanner output.
- **Blast-radius guards** — the tool refuses to run without an explicit authorized scope, and refuses a scope wider than a `/16`. Output is written owner-only (`umask 0o077`). SSH uses a strict host-key `RejectPolicy`.

## How I built it with AI

This is the part the repo is really about.

- **I drove, the AI drafted.** Claude Code wrote code against my design; I reviewed every change and owned every decision. All 31 commits carry a `Co-Authored-By: Claude` trailer — I don't hide that.
- **Phased build.** A walking skeleton first, then five agents hardened distinct modules with exclusive file ownership to avoid collisions, then the four security phases, then a cleanup pass.
- **Review discipline in the loop.** Commits reference repeated `/code-review` and `/simplify` passes. Conventional commit style throughout (`feat:`, `fix:`, `security(phase N):`).
- **Steering for honesty.** An `AGENTS.md` file (my own writing/organization rules — see [`../artifacts/`](../artifacts/)) kept the docs plain and free of filler. There's literally a commit titled `docs: replace vague adjectives per AGENTS.md`.

The result reads like something a person built with care, because the review gate never came off.

## Results

- **116 tests, all passing** (verified by running the suite, not by trusting the count). They're decision-table tests over a fake remote host and real XCCDF-parsing fixtures — they exercise the load-bearing status logic, not trivial getters.
- **End-to-end offline render works** — `python smoketest.py` produces a full HTML report with executive summary, coverage map, severity breakdown, and fleet trend.
- **Live path validated** once, by hand, against a real cloud Ubuntu 22.04 host, with the negative paths checked. The runbook is in `docs/validation.md`.
- **A 90-entry CIS-to-NIST-800-53 / ISO-27001 crosswalk**, labeled non-authoritative and orientation-only throughout — because a hand-curated mapping should never be mistaken for an official control assessment.

## Limitations, stated plainly

I'd rather name these than have an interviewer find them.

- **No CI yet.** 116 tests pass, but nothing runs them automatically. This is the first thing I'd add. It's the softest spot in the "validation complete" claim.
- **Live-validated on one host, once.** Offline logic is well covered; a real multi-host fleet run at scale hasn't happened. I don't yet know how it behaves across 200 hosts.
- **Ubuntu-only, assessment-only, active-scan-only.** No other OS, no auto-remediation, no CMDB ingestion. All deliberately out of scope for v1 and documented as such.
- **The crosswalk is indicative, not authoritative.** It's labeled that way everywhere, but a reader skimming the report could over-trust it.

## What I'd do next

Add GitHub Actions CI with the test suite as a merge gate. Run a real multi-host fleet and document the results. Then decide whether a second OS profile earns its complexity.

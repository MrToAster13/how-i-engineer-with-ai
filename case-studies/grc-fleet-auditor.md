# GRC Fleet Auditor

A Python CLI that audits a fleet of Ubuntu hosts against the CIS Benchmark and produces audit-defensible compliance evidence. I designed it, built it with an AI pair, and hardened it in four security phases plus later security fixes.

Code: [`MrToAster13/grc-fleet-scanner`](https://github.com/MrToAster13/grc-fleet-scanner)

## The problem

A GRC analyst needs to answer one question about a fleet of servers: which hosts meet the benchmark, and where's the proof? The proof matters as much as the answer. An auditor won't accept "trust me". They want evidence they can trace back to an authoritative source.

The trap is a tool that reports a clean pass when it didn't check. A host that was unreachable, or missing the scanner, or scanned only partially, cannot be called compliant. Calling it compliant anyway is how a bad audit gets signed.

## What I built

The tool wraps OpenSCAP and the SCAP Security Guide rather than reimplementing compliance checks. That's a deliberate call. Verdicts come from the authoritative scanner, so they hold up in an audit. My work is the orchestration around it.

The pipeline:

```
discover (nmap) → classify → reach (SSH) → detect (oscap/SSG) → scan (oscap)
  → persist (SQLite) → report (HTML/JSON/CSV + run-over-run drift)
```

The package is about 5,000 lines of Python, with a larger test suite beside it. Each run writes to `grc-output/runs/<run_id>/`. A run folder holds the HTML report, machine-readable JSON and CSV, an audit log, the effective config, the raw OpenSCAP evidence per host, and a `manifest.json` with SHA-256 digests of the report files and the per-host evidence. A reviewer can use the manifest to confirm those files were not edited after the fact.

## The decision I'm proudest of: never a false pass

Every host lands in exactly one honest coverage bucket: `scanned`, `non_ubuntu`, `no_credentials`, `unreachable`, `scanner_absent`, `unsupported_version`, `host_key_mismatch`, or `scan_error`. Partial coverage is never dressed up as a clean result.

Two mechanisms enforce it:

- A single function, `assess.scan_verdict`, gates the `scanned` verdict, and only `assess` writes a host's verdict after triage. Nothing else can mark a host compliant. An ADR in the repo records why I collapsed four writers into one.
- A hard confidence floor. A scan where fewer than 50% of the profile's selected checks returned a verdict becomes `scan_error`, not a pass. No config setting can lower that floor.

I also had to re-derive the confidence denominator so that rules outside the selected profile couldn't inflate or tank the score. That fix is documented in the changelog.

The same principle guards the NIST 800-53 control rollup. When a merged evidence file repeats a rule with conflicting verdicts, a verdict precedence keeps the most decision-critical one. An errored check can never be buried under a later pass and read as `Implemented`. The first version protected only a `fail`. The fix ships with two regression tests.

The point: the tool would rather under-report than certify a host it didn't assess. That's the judgment a GRC role hires for.

## Security hardening

The scanner runs commands on remote hosts over SSH, so it's a real attack surface. I worked through it in phases:

- **Remote command injection.** A malicious host could return a crafted `mktemp` path that reached a `sudo` command. Fixed, with a regression test (`test_malicious_mktemp_output_is_refused`) that feeds a shell-injection payload and asserts it's refused.
- **Stored XSS and CSV injection** in the generated reports. Fixed, since reports get opened in browsers and spreadsheets.
- **XML parsing** hardened with `defusedxml` against entity-expansion attacks on scanner output.
- **Blast-radius guards.** The tool refuses to run without an explicit authorized scope, and refuses an IPv4 scope wider than a `/16` or an IPv6 scope wider than a `/112`. Output is written owner-only (`umask 0o077`). SSH uses a strict host-key `RejectPolicy`.

## How I built it with AI

This is the part the repo is about.

- **I drove, the AI drafted.** Claude Code wrote code against my design. I reviewed every change and owned every decision. Most commits carry a `Co-Authored-By: Claude` trailer, and I don't hide that.
- **Phased build.** A walking skeleton came first. Then five agents hardened distinct modules with exclusive file ownership to avoid collisions. Then came four security phases, three more hardening phases, and a cleanup pass.
- **Review discipline in the loop.** Commit messages cite `/code-review` and `/simplify` passes. The security work uses `security(phase N):` commit subjects.
- **Steering for honesty.** From June to October 2026, an `AGENTS.md` holding my own writing rules kept the docs plain and free of filler, see [`../artifacts/`](../artifacts/). There's a commit titled `docs: replace vague adjectives per AGENTS.md`.

The result reads like something a person built with care, because the review gate never came off.

## Results

- **A pytest suite, all passing.** I verify it by running it, not by trusting a count. The current number is whatever `python -m pytest` reports in [the repo](https://github.com/MrToAster13/grc-fleet-scanner). GitHub Actions runs it on Python 3.8, 3.11, and 3.13 on every push to main and every pull request. A local pre-commit hook also runs it before each commit. The tests are decision tables over a fake remote host and real XCCDF-parsing fixtures. They exercise the load-bearing status logic, not trivial getters.
- **End-to-end offline render works.** `python smoketest.py` produces a full HTML report with an executive summary, a coverage map, failing controls by severity, and a fleet trend.
- **Live path validated** by hand on 2026-06-30 against a real cloud Ubuntu 22.04 host. The scan path has changed since then, and the current code has not run against a live host. The runbook is in `docs/validation.md`.
- **A NIST 800-53 control rollup** built from the scan's own evidence. Each rule's 800-53 references come from the SCAP datastream itself, so the mapping is the benchmark's, not mine. The status it suggests is labeled a suggestion, never an authorization decision. It replaced an earlier hand-curated CIS-to-NIST crosswalk that I cut for not being authoritative.

## Limitations, stated plainly

I'd rather name these than have an interviewer find them.

- **Live-validated on one host, once, in June 2026.** The pytest suite covers the offline logic, and CI gates it. The current code has not run against a live host, and a real multi-host fleet run hasn't happened. I don't yet know how it behaves across 200 hosts. This is the softest spot in the tool's validation.
- **Ubuntu-only, assessment-only, active-scan-only.** No other OS, no auto-remediation, no CMDB ingestion. All are deliberately out of scope for v1 and documented as such.
- **The rollup's status is a suggestion.** The tool labels "Implemented" and "Planned" as suggestions from automated checks, and an ISSO still writes each control narrative. A reader skimming the report could still over-trust it.

## What I'd do next

Run a real multi-host fleet and document the results. Then decide whether a second OS profile earns its complexity.

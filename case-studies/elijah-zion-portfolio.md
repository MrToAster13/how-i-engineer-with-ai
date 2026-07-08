# elijah-zion.com — built with an AI pair, verified in the artifact

My résumé site, built from scratch with an AI pair. It's here for how it was made, not for what it says: I re-checked every design and honesty claim against the built output before I trusted it.

Live: [elijah-zion.com](https://elijah-zion.com). The repo (`elijahzion-portfolio`) is private.

## What it is

A static Astro site, deployed on Cloudflare Pages through git-integrated builds: push the branch, Cloudflare builds and ships it. About 15 components cover the full information architecture, from hero through projects, certs, experience, about, and contact. The writeups run through a typed Astro content collection with draft-gating, so anything still marked a draft is dropped from the production build, and the section numbers renumber themselves as entries come and go.

That's the site. It's small. What earns it a case study is the method.

## Two workflows I wrote for the build

Design review is easy to fake. An agent skims the CSS, declares it fine, and you've learned nothing. I wanted findings I could act on, so I wrote two workflow scripts for this build.

- **`redesign-preflight-review`** runs parallel finders, one per lens: accessibility with actual computed WCAG contrast ratios rather than eyeballed ones, responsive layout, and CSS correctness. Every finding is adversarially verified before it survives, so a flag has to hold up against a check and I never act on noise.
- **`mobile-spacing-audit`** points one agent at each component and forces a strict JSON output schema — selector, issue, severity, fix. Structured output means I triage the results instead of reading prose.

## Verify in the artifact, not the source

This is the habit I care most about here. I checked the thing that actually ships, not the thing I wrote.

- The honesty rules were re-grepped against the built `dist/index.html`, not the source templates. The source is intent; the build is fact.
- After a deploy I polled the live Cloudflare URL until propagation confirmed the change was really up, instead of assuming the push had done it.
- When an automated pass flagged dead code, I re-verified every zero-reference claim by hand before deleting anything. That caught a false positive: `--shadow-lg` was reported as unused, but it was referenced, so I kept it. Deleting on the reviewer's word would have been the mistake.

## The gates before it shipped

- `astro check` had to return zero type errors.
- A manual security-review pass: `npm audit` clean at 0 vulnerabilities, plus a scan for committed secrets and PII.
- A git-push guardrail hook was in place. When the build wanted to push, it stopped and handed the push to me, and I ran it. The guardrail did its job.

## Honest limits

- It's a small personal site. I'm not dressing that up. The interesting part is the build discipline, not the surface area.
- Some writeups are still drafts, deliberately excluded from the production build. They ship when they're done, not before.
- The security pass and the design workflows ran against a small codebase. They show the habit, not a stress test at scale.

## What it demonstrates

I treat AI output as a claim to verify, not an answer to accept. I checked the built artifact instead of the source, re-verified a reviewer before deleting code, and let a guardrail hand me the one irreversible step. The site is modest. The method is the one I'd bring to something that isn't.

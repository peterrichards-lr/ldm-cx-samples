# Contributing

## Commit & PR Hygiene

- **Keep unrelated changes in separate commits/PRs.** A dependency-vulnerability fix and a bulk documentation pass (e.g. re-stamping doc timestamp footers) are two PRs, not one — bundling them makes both harder to review and hides doc-only changes inside a security fix (see [#11](https://github.com/peterrichards-lr/ldm-cx-samples/issues/11)).
- **Don't use a `[bypass limit]` tag in PR titles.** This repo has no PR-size/sprawl-limit CI gate, so the tag doesn't bypass anything — it just misleadingly implies a check exists. If large PRs become a real problem, add an actual size-gate workflow instead of a tag that refers to nothing.
- Debug/job-runner artifacts (`audit.txt`, `job_log.txt`, `jobs.json`, `logs.zip`, and similar local tooling output) must never be committed. They're gitignored — if your tool writes them into the repo root, clean them up before committing.

<!-- markdownlint-disable MD049 -->

---

_Last Updated: 2026-08-06_ | _Last Reviewed: 2026-08-06_

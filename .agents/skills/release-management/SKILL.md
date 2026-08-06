---
name: release-management
description: Activate this skill whenever a PR is merging to main, cutting a release, or explaining/adjusting how the .ldmp package is built and published.
---

# Release Management

This repo has **no manual tagging step** and no semver-bump decision to make by hand — release is fully automated by [`.github/workflows/package-ldmp.yml`](../../../.github/workflows/package-ldmp.yml). Don't invent a manual `git tag`/`gh release create` flow; describe (or adjust) the real one below.

### What happens on merge to `main`

1. **Auto-tag**: `mathieudutour/github-tag-action` bumps a `vMAJOR.MINOR.PATCH` tag, defaulting to a **patch** bump (`default_bump: patch`) unless a commit message signals otherwise (that action reads `major:`/`minor:`/`patch:`/`none:` prefixes in commit messages — there's no manual version decision to make here).
2. **Build**: `./gradlew clean build` compiles every client extension.
3. **Package**: `scripts/package-ldmp.sh` stages compiled client-extension ZIPs, fragments, OSGi configs, and a generated `meta` manifest, then tars it into `ldm-cx-samples.ldmp` with a `.sha256` sidecar.
4. **Publish**: `softprops/action-gh-release` creates a GitHub Release on the new tag and uploads `ldm-cx-samples.ldmp` + `ldm-cx-samples.ldmp.sha256` as release assets.

### Re-attaching a package to an existing tag

The workflow also accepts `workflow_dispatch` with a `release_tag` input — use this to rebuild and re-upload the `.ldmp` to an already-existing tag (e.g. fixing a bad package without minting a new version). It skips the auto-tag step (that only runs `if: github.ref == 'refs/heads/main'`) and publishes against the tag you pass in.

### If you're touching this pipeline

- `scripts/run-e2e.sh` exercises the same `package-ldmp.sh` script against a locally cloned `liferay-docker-manager` to catch packaging regressions before they reach a release — run it (or trust CI's `E2E Tests` workflow) before changing `package-ldmp.sh`'s staging logic.
- The `.ldmp`/`.ldmp.sha256` files are gitignored and must never be committed directly — they're build output, only ever published as release assets.
- This skill deliberately doesn't cover manual semantic-version judgment calls (major vs. minor vs. patch) because none exist in this repo's process; if you need one (e.g. to force a major bump), that's a change to this workflow's config, not a one-off manual tag.

<!-- markdownlint-disable MD049 -->

---

_Last Updated: 2026-08-06_ | _Last Reviewed: 2026-08-06_

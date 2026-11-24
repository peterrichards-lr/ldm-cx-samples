---
name: release-management
description: Activate this skill whenever cutting a release, merging to main, or explaining/adjusting how the .ldmp package is built and published.
---

# Release Management

LDM ([liferay-docker-manager](https://github.com/peterrichards-lr/liferay-docker-manager)) downloads `releases/latest/download/ldm-cx-samples.ldmp` directly, so every release here reaches LDM users immediately. That's why releases are **deliberate**: merging to `main` does not publish anything. A release happens only when someone pushes a `v*` tag, via [`.github/workflows/package-ldmp.yml`](../../../.github/workflows/package-ldmp.yml).

### Merging to `main`

Merging builds nothing and releases nothing. Only the `E2E Tests` workflow runs. Docs and other changes can merge freely.

### Cutting a release

Cut a release only with the maintainer's agreement.

1. Pick the next `vMAJOR.MINOR.PATCH` tag. Check the latest one with `git tag --sort=-v:refname | head -1`, and use semver: bump patch for fixes, minor for new sample content, major for package-format changes that need a newer LDM.
2. Tag the commit on `main` and push the tag:

    ```bash
    git tag v1.3.4 origin/main
    git push origin v1.3.4
    ```

3. The tag push triggers the workflow:
    - **Build**: `./gradlew clean build` compiles every client extension.
    - **Package**: `tools/build-ldmp.sh` installs the LDM release pinned in `tools/lib/ldm.sh` (the verified release binary, not pip), links the built workspace into an LDM project with `ldm link --no-run`, then runs `ldm package --stateless`. Liferay is never started, so no licence is involved, and Liferay's auto-deploy can't empty `deploy/` before packaging. The result is an assets-only package (`package_kind: stateless`, LDM-#2493) that LDM deploys onto a vanilla instance, with the site initializers held in `.ldm/deferred-client-extensions/` until Liferay is healthy.
    - **Publish**: `softprops/action-gh-release` creates a GitHub Release on the tag and uploads `ldm-cx-samples.ldmp` and `ldm-cx-samples.ldmp.sha256` as release assets.

### Re-attaching a package to an existing tag

Run the workflow manually (`workflow_dispatch`) with the required `release_tag` input. This checks out that tag, rebuilds the `.ldmp` and re-uploads it to the tag's release. Use it to fix a bad package without minting a new version.

### If you're touching this pipeline

- `tools/run-e2e.sh` builds the package with the same `build-ldmp.sh`, checks its contents (top-level `files.tar.gz` and `meta`, the fragment zips and `.ldm/fragment-overrides.json`, no runtime state or licence), then seeds a project with `ldm init --samples` (via `LDM_SAMPLES_PATH`). CI runs it on every PR and weekly. The seeding step uses Docker, so ask the maintainer before running it locally.
- The LDM pin (`LDM_VERSION`) lives in `tools/lib/ldm.sh` and is shared by both scripts. When LDM releases a version this repo should support, bump it in its own PR.
- The `.ldmp` and `.ldmp.sha256` files are build output. Never commit them; they're only ever published as release assets.
- Keep a top-level `files.tar.gz` in the package: LDM v2.26.x reads only that member.

<!-- markdownlint-disable MD049 -->

---

_Last Updated: 2026-11-24_ | _Last Reviewed: 2026-11-24_

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
    - **Package**: `scripts/package-ldmp.sh` stages the compiled client-extension ZIPs, fragments, OSGi configs and a generated `meta` manifest, then tars them into `ldm-cx-samples.ldmp` with a `.sha256` sidecar.
    - **Publish**: `softprops/action-gh-release` creates a GitHub Release on the tag and uploads `ldm-cx-samples.ldmp` and `ldm-cx-samples.ldmp.sha256` as release assets.

### Re-attaching a package to an existing tag

Run the workflow manually (`workflow_dispatch`) with the required `release_tag` input. This checks out that tag, rebuilds the `.ldmp` and re-uploads it to the tag's release. Use it to fix a bad package without minting a new version.

### If you're touching this pipeline

- `scripts/run-e2e.sh` runs the same `package-ldmp.sh` against a pinned LDM release (`LDM_VERSION`, default set in the script), to catch packaging regressions before they reach a release. Its Liferay tag comes from `liferay.workspace.product` in `gradle.properties`. CI also runs it weekly. When LDM releases a version this repo should support, bump `LDM_VERSION` in its own PR. Run it (or rely on CI's `E2E Tests` workflow) before changing `package-ldmp.sh`'s staging logic. It uses Docker, so ask the maintainer before running it locally.
- The `.ldmp` and `.ldmp.sha256` files are build output. Never commit them; they're only ever published as release assets.
- The plan is to replace `package-ldmp.sh` with `ldm package --stateless` once LDM supports it (#17, LDM #2493). Until then, keep the current package layout: LDM v2.26.x reads a top-level `files.tar.gz`.

<!-- markdownlint-disable MD049 -->

---

_Last Updated: 2026-11-23_ | _Last Reviewed: 2026-11-23_

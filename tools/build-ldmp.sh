#!/bin/bash
# tools/build-ldmp.sh
# Builds ldm-cx-samples.ldmp (+ .sha256) in the repo root with LDM itself:
# `ldm package --stateless` (LDM-#2493), an assets-only package that LDM
# deploys onto a vanilla instance. Used by the release workflow and by
# run-e2e.sh, so CI tests the exact package a release would publish.
#
# Liferay is never started: a stateless package is built from the project's
# files alone, and LDM stores the site initializers in
# .ldm/deferred-client-extensions/ itself. So no Docker boot and no licence.
# (Booting first would also let auto-deploy empty deploy/ before packaging.)
#
# Expects the client extensions to be built already (./gradlew clean build).
set -euo pipefail

# This repo keeps its tooling in tools/, never scripts/: LDM copies a
# workspace's scripts/ into the project, Liferay runs everything in it before
# the portal starts, and `ldm package` ships it to every user.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=tools/lib/ldm.sh
source "${REPO_ROOT}/tools/lib/ldm.sh"

PROJECT_ID="ldm-cx-samples"
GIT_REPO="peterrichards-lr/ldm-cx-samples"
PACKAGE="${REPO_ROOT}/${PROJECT_ID}.ldmp"
WORK_DIR="${LDM_BUILD_DIR:-$(mktemp -d)}"
mkdir -p "$WORK_DIR"

if ! compgen -G "${REPO_ROOT}/client-extensions/*/dist/*.zip" >/dev/null; then
    echo "❌ ERROR: no built client extensions; run ./gradlew clean build first."
    exit 1
fi

if ! command -v ldm >/dev/null 2>&1 || [ "${LDM_FORCE_INSTALL:-}" = "1" ]; then
    install_ldm "${WORK_DIR}/bin"
fi

echo "📦 Packaging ${PROJECT_ID} with LDM ${LDM_VERSION}"
cd "$WORK_DIR"

# 1. Create the LDM project from the built workspace, without starting it.
#    The tag and database come from the workspace (gradle.properties).
ldm -y link "$REPO_ROOT" "$PROJECT_ID" --no-run --no-monitor --db postgresql

# 2. Package the project's assets.
OUT_DIR="${WORK_DIR}/dist"
mkdir -p "$OUT_DIR"
ldm package "$PROJECT_ID" --stateless --non-interactive --repo "$GIT_REPO" --output "$OUT_DIR"

built=("$OUT_DIR"/*.ldmp)
if [ "${#built[@]}" -ne 1 ] || [ ! -f "${built[0]}" ]; then
    echo "❌ ERROR: expected exactly one .ldmp in ${OUT_DIR}, found: ${built[*]}"
    exit 1
fi

# LDM downloads releases/latest/download/ldm-cx-samples.ldmp by name, so the
# asset name is fixed whatever LDM calls the file.
mv "${built[0]}" "$PACKAGE"
if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$PACKAGE" | awk '{print $1}' > "${PACKAGE}.sha256"
else
    shasum -a 256 "$PACKAGE" | awk '{print $1}' > "${PACKAGE}.sha256"
fi

echo "✅ Package created: ${PACKAGE} ($(du -h "$PACKAGE" | cut -f1))"

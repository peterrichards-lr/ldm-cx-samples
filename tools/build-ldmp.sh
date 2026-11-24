#!/bin/bash
# tools/build-ldmp.sh
# Builds ldm-cx-samples.ldmp (+ .sha256) in the repo root with LDM itself:
# `ldm package --stateless` (LDM-#2493), an assets-only package that LDM
# deploys onto a vanilla instance. Used by the release workflow and by
# run-e2e.sh, so CI tests the exact package a release would publish.
#
# Needs Docker, and a DXP activation key in LIFERAY_ACTIVATION_KEY_XML (the
# XML itself, not a path): the site initializers only reach the package once
# Liferay has booted and LDM has deployed them. LDM strips licences from the
# package (LDM-#2443), so the key never ships.
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
LIFERAY_TAG="$(sed -n 's/^liferay\.workspace\.product=dxp-//p' "${REPO_ROOT}/gradle.properties")"

if [ -z "$LIFERAY_TAG" ]; then
    echo "❌ ERROR: could not read liferay.workspace.product from gradle.properties"
    exit 1
fi
if [ -z "${LIFERAY_ACTIVATION_KEY_XML:-}" ]; then
    echo "❌ ERROR: LIFERAY_ACTIVATION_KEY_XML is not set. An unlicensed portal never"
    echo "   deploys the site initializers, so the package would ship without them."
    exit 1
fi

if ! command -v ldm >/dev/null 2>&1 || [ "${LDM_FORCE_INSTALL:-}" = "1" ]; then
    install_ldm "${WORK_DIR}/bin"
fi

echo "📦 Packaging ${PROJECT_ID} with LDM ${LDM_VERSION} (Liferay ${LIFERAY_TAG})"
cd "$WORK_DIR"

# On failure, keep the evidence before the stack goes away. CI uploads
# LDM_DIAG_DIR as an artifact.
DIAG_DIR="${LDM_DIAG_DIR:-${WORK_DIR}/diagnostics}"
cleanup() {
    local status=$?
    if [ "$status" -ne 0 ]; then
        echo "⚠️ Build failed (exit ${status}); collecting diagnostics in ${DIAG_DIR}"
        mkdir -p "$DIAG_DIR"
        docker inspect -f '{{.State.ExitCode}} {{.State.Error}} OOMKilled={{.State.OOMKilled}}' \
            "$PROJECT_ID" > "${DIAG_DIR}/liferay-state.txt" 2>&1 || true
        docker logs --tail 500 "$PROJECT_ID" > "${DIAG_DIR}/liferay.log" 2>&1 || true
        cp "${WORK_DIR}/${PROJECT_ID}/docker-compose.yml" "$DIAG_DIR/" 2>/dev/null || true
        ls -laR "${WORK_DIR}/${PROJECT_ID}/scripts" "${WORK_DIR}/${PROJECT_ID}/deploy" \
            > "${DIAG_DIR}/project-dirs.txt" 2>&1 || true
        tail -n 100 "${DIAG_DIR}/liferay.log" || true
    fi
    ldm down "$PROJECT_ID" --non-interactive || true
    return "$status"
}
trap cleanup EXIT

# 1. Create the LDM project from the workspace without booting it, so the
#    licence can go into deploy/ first.
ldm -y link "$REPO_ROOT" "$PROJECT_ID" --no-run --no-monitor --db postgresql

DEPLOY_DIR="${WORK_DIR}/${PROJECT_ID}/deploy"
mkdir -p "$DEPLOY_DIR"
printf '%s' "$LIFERAY_ACTIVATION_KEY_XML" > "${DEPLOY_DIR}/activation-key.xml"
echo "Staged activation key ($(wc -c < "${DEPLOY_DIR}/activation-key.xml") bytes)."

# 2. Boot, and wait until every deployable (including the deferred site
#    initializers) is in.
ldm -y run "$PROJECT_ID" -t "$LIFERAY_TAG"
ldm wait "$PROJECT_ID" --non-interactive --wait-for-deployables

# 3. Package the assets.
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

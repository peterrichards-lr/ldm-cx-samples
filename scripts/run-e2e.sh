#!/bin/bash
# scripts/run-e2e.sh
# Builds the .ldmp exactly as a release does (scripts/build-ldmp.sh), checks
# its contents, then seeds a fresh LDM project from it with --samples.
#
# Needs Docker and LIFERAY_ACTIVATION_KEY_XML (see build-ldmp.sh). Uses the
# LDM release pinned in scripts/lib/ldm.sh.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=scripts/lib/ldm.sh
source "${REPO_ROOT}/scripts/lib/ldm.sh"
cd "$REPO_ROOT"

PACKAGE="ldm-cx-samples.ldmp"
FAILED=0
fail() {
    echo "❌ $*"
    FAILED=1
}

echo "🚀 Starting E2E Test for LDM Samples (LDM ${LDM_VERSION})"

# 1. Build the client extensions.
echo "🔨 Building client extensions..."
./gradlew clean build

# 2. Install the pinned LDM and build the package with it.
LDM_BIN_DIR="$(mktemp -d)"
install_ldm "$LDM_BIN_DIR"
./scripts/build-ldmp.sh

# 3. Check the package statically.
echo "🔍 Checking package contents..."
INSPECT_DIR="$(mktemp -d)"
tar -xzf "$PACKAGE" -C "$INSPECT_DIR"

# LDM v2.26.x reads only a top-level files.tar.gz, so it must stay there.
[ -f "${INSPECT_DIR}/files.tar.gz" ] || fail "no top-level files.tar.gz"
[ -f "${INSPECT_DIR}/meta" ] || fail "no top-level meta"

python3 - "${INSPECT_DIR}/meta" <<'PY' || FAILED=1
import json, sys
meta = json.load(open(sys.argv[1], encoding="utf-8"))
ok = True
for key, want in (("package_kind", "stateless"), ("db_type", "postgresql")):
    if meta.get(key) != want:
        print(f"❌ meta {key!r} is {meta.get(key)!r}, expected {want!r}")
        ok = False
if not meta.get("tag"):
    print("❌ meta has no 'tag'")
    ok = False
sys.exit(0 if ok else 1)
PY

PAYLOAD="$(tar -tzf "${INSPECT_DIR}/files.tar.gz")"
for want in \
    '\.ldm/fragment-overrides\.json$' \
    '^(\./)?deploy/ecopulse-supplemental-fragments\.zip$' \
    '^(\./)?deploy/responsive-menus\.zip$' \
    '/ecopulse-theme[^/]*\.zip$' \
    '/ecopulse-site-initializer[^/]*\.zip$' \
    '/veridian-site-initializer[^/]*\.zip$'; do
    grep -Eq "$want" <<<"$PAYLOAD" || fail "package is missing ${want}"
done

# Never ship runtime state or a licence.
for banned in \
    '(^|/)data/' \
    '(^|/)osgi/state/' \
    '(^|/)snapshots/' \
    '(^|/)routes/' \
    'activation-key[^/]*\.xml$' \
    '\.lpkg$'; do
    if grep -Eq "$banned" <<<"$PAYLOAD"; then
        fail "package contains ${banned}"
    fi
done
echo "📏 Package size: $(du -h "$PACKAGE" | cut -f1)"

# 4. Seed a new project from the package, as `ldm run --samples` does.
# A copied-in cache would be replaced by the published release (LDM-#2491), so
# point LDM at an extracted samples root instead: LDM_SAMPLES_PATH takes
# priority over the cache and never downloads. It wants files.tar.gz extracted,
# with the package's meta at the top (read for tag, db_type and package_kind).
echo "📥 Extracting the package as the samples root..."
SAMPLES_ROOT="$(mktemp -d)"
tar -xzf "${INSPECT_DIR}/files.tar.gz" -C "$SAMPLES_ROOT"
cp "${INSPECT_DIR}/meta" "${SAMPLES_ROOT}/meta"
export LDM_SAMPLES_PATH="$SAMPLES_ROOT"

echo "🏗️ Initializing test project with --samples..."
TEST_WORKSPACE="${REPO_ROOT}/e2e-workspace"
sudo rm -rf "$TEST_WORKSPACE"
mkdir -p "$TEST_WORKSPACE"
cd "$TEST_WORKSPACE"
docker network create liferay-net || true
ldm init e2e-test -y --samples --host-name sample.local --no-ssl

echo "🔍 Verifying the seeded project..."
cd e2e-test
# Site initializers may be held back until first boot (LDM-#1779), so accept
# either location.
for cx in ecopulse-theme veridian-site-initializer; do
    if ! ls osgi/client-extensions/"${cx}"*.zip .ldm/deferred-client-extensions/"${cx}"*.zip >/dev/null 2>&1; then
        fail "${cx} ZIP was not hydrated into the project"
    fi
done
[ -f .ldm/fragment-overrides.json ] || fail ".ldm/fragment-overrides.json was not hydrated"

echo "🧹 Cleaning up test workspace..."
cd "$REPO_ROOT"
sudo rm -rf "$TEST_WORKSPACE" "$INSPECT_DIR" "$SAMPLES_ROOT"

if [ "$FAILED" -ne 0 ]; then
    echo "❌ E2E tests failed."
    exit 1
fi
echo "🎉 E2E Tests Completed Successfully!"

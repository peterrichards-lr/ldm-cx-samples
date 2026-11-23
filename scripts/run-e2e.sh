#!/bin/bash
# scripts/run-e2e.sh
# Tests the LDM .ldmp samples packaging and initialization workflow.
set -e

# Pinned LDM release to test against. Bump it deliberately, as a reviewed
# change, so an LDM regression can't silently break this repo's CI.
# Override for a one-off run with: LDM_VERSION=v2.27.0 ./scripts/run-e2e.sh
LDM_VERSION="${LDM_VERSION:-v2.26.15}"

# Liferay tag for the test project, taken from the workspace product so the
# two can't drift (e.g. dxp-2026.q1.14-lts -> 2026.q1.14-lts).
LIFERAY_TAG="$(sed -n 's/^liferay\.workspace\.product=dxp-//p' gradle.properties)"
if [ -z "$LIFERAY_TAG" ]; then
    echo "❌ ERROR: could not read liferay.workspace.product from gradle.properties"
    exit 1
fi

echo "🚀 Starting E2E Test for LDM Samples (LDM ${LDM_VERSION}, Liferay ${LIFERAY_TAG})"

# 1. Build Client Extensions (if not already built)
echo "🔨 Building client extensions..."
./gradlew clean build

# 2. Package the .ldmp
echo "📦 Packaging samples..."
chmod +x scripts/package-ldmp.sh
./scripts/package-ldmp.sh

# 3. Clone and install LDM CLI locally
echo "⚙️ Setting up Liferay Docker Manager..."
LDM_DIR="/tmp/ldm-e2e-repo"
rm -rf "$LDM_DIR"
git clone --depth 1 --branch "$LDM_VERSION" https://github.com/peterrichards-lr/liferay-docker-manager.git "$LDM_DIR"
cd "$LDM_DIR"

# We don't control the state of the cloned repo's checked-in tree, so don't
# assume .venv is absent - a stray tracked file/symlink/dir at that path
# (e.g. an accidentally-committed local venv symlink upstream) makes
# `python3 -m venv .venv` fail with [Errno 17] File exists. `rm -rf` on a
# symlink only removes the link itself, not its target, so this is safe.
rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
pip install -e .

# Return to original repo dir
cd - > /dev/null

# 4. Mock the downloaded cache
echo "📥 Mocking downloaded samples cache..."
mkdir -p ~/.ldm/references/samples
cp ldm-cx-samples.ldmp ~/.ldm/references/samples/samples_latest.ldmp

# 5. Initialize a test project using LDM
echo "🏗️ Initializing test project with --samples..."
TEST_WORKSPACE="$(pwd)/e2e-workspace"
sudo rm -rf "$TEST_WORKSPACE"
mkdir -p "$TEST_WORKSPACE"
cd "$TEST_WORKSPACE"

# Initialize with the built-in LDM binary from the virtual environment
# Ensure liferay-net exists for global proxy routing (required by latest LDM architecture)
docker network create liferay-net || true
"$LDM_DIR/.venv/bin/ldm" init e2e-test -y --samples --tag "$LIFERAY_TAG" --host-name sample.local --no-ssl

echo "🔍 Verifying extraction in the initialized workspace..."
cd e2e-test

# Check if essential sample ZIPs were successfully extracted into the workspace
MISSING=0
if ! ls client-extensions/ecopulse-theme*.zip 1> /dev/null 2>&1; then
    echo "❌ ERROR: ecopulse-theme ZIP is missing from client-extensions/!"
    MISSING=1
fi

if ! ls client-extensions/veridian-site-initializer*.zip 1> /dev/null 2>&1; then
    echo "❌ ERROR: veridian-site-initializer ZIP is missing from client-extensions/!"
    MISSING=1
fi

if [ "$MISSING" -eq 1 ]; then
    echo "❌ E2E tests failed! Sample assets were not correctly hydrated."
    exit 1
fi

echo "✅ All validations passed!"
echo "🎉 E2E Tests Completed Successfully!"

echo "🧹 Cleaning up test workspace..."
cd "$TEST_WORKSPACE/.."
sudo rm -rf "$TEST_WORKSPACE"

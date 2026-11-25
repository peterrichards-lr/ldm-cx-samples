#!/bin/bash
# tools/check-ldmp.sh <package.ldmp>
# Checks a built .ldmp statically: layout, meta, required assets, and nothing
# that must never ship (a licence, runtime state, a scripts/ tree). Run by
# run-e2e.sh on every PR and by the release workflow before it uploads, so a
# tag pushed on an untested commit still can't publish a bad package.
set -euo pipefail

PACKAGE="${1:?usage: check-ldmp.sh <package.ldmp>}"
FAILED=0
fail() {
    echo "❌ $*"
    FAILED=1
}

echo "🔍 Checking package contents of ${PACKAGE}..."
INSPECT_DIR="$(mktemp -d)"
trap 'rm -rf "$INSPECT_DIR"' EXIT
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
echo "📋 Payload layout (entries per top-level path):"
awk -F/ '{sub(/^\.\//, ""); print $1 "/" $2}' <<<"$PAYLOAD" | sort | uniq -c
echo "📋 Payload files under scripts/, deploy/, .ldm/ and osgi/client-extensions/:"
grep -E '^(\./)?(scripts|deploy|\.ldm|osgi/client-extensions)/' <<<"$PAYLOAD" | grep -v '/$' || true
for want in \
    '\.ldm/fragment-overrides\.json$' \
    '^(\./)?deploy/ecopulse-supplemental-fragments\.zip$' \
    '^(\./)?deploy/responsive-menus\.zip$' \
    '/ecopulse-theme[^/]*\.zip$' \
    '/ecopulse-site-initializer[^/]*\.zip$' \
    '/veridian-site-initializer[^/]*\.zip$'; do
    grep -Eq "$want" <<<"$PAYLOAD" || fail "package is missing ${want}"
done

# Never ship runtime state, a licence, or a scripts/ tree: Liferay runs every
# script in /mnt/liferay/scripts before the portal starts, on the user's machine.
# Zips belong in osgi/client-extensions, .ldm/deferred-client-extensions or
# deploy/, never loose in client-extensions/ (a stray build-dir
# site-initializer.zip once added ~50 MB; fixed in LDM v2.26.16-pre.2). Site initializers are LCP `kind: Job`,
# so their expanded folder ships descriptors only and the images travel once,
# inside the zip (LDM-#2493 fix in v2.26.16-pre.1).
for banned in \
    '(^|/)data/' \
    '(^|/)osgi/state/' \
    '(^|/)snapshots/' \
    '(^|/)routes/' \
    'activation-key[^/]*\.xml$' \
    '(^|/)[^/]*licen[cs]e[^/]*\.(xml|li[cs])$' \
    '\.lpkg$' \
    '^(\./)?scripts/.+[^/]$' \
    'client-extensions/[^/]*site-initializer/.*\.png$' \
    '^(\./)?client-extensions/[^/]+\.zip$'; do
    if grep -Eq "$banned" <<<"$PAYLOAD"; then
        fail "package contains ${banned}"
    fi
done
echo "📏 Package size: $(du -h "$PACKAGE" | cut -f1)"

if [ "$FAILED" -ne 0 ]; then
    echo "❌ Package check failed."
    exit 1
fi
echo "✅ Package check passed."

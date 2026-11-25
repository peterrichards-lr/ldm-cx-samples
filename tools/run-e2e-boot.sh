#!/bin/bash
# tools/run-e2e-boot.sh
# Boots Liferay from the .ldmp the way `ldm run --samples` does, then checks
# that LDM deployed the site initializers and both sites came up themed.
# run-e2e.sh stops before the boot; this covers what happens after it.
#
# Needs Docker and a DXP activation key in LIFERAY_ACTIVATION_KEY_XML. The
# key goes into this throwaway project's deploy/ only; it is never packaged.
# Uses the LDM release pinned in tools/lib/ldm.sh.
#
# By default it builds the package (tools/build-ldmp.sh, which expects
# ./gradlew clean build to have run). Set LDMP=/path/to/ldm-cx-samples.ldmp to
# boot an existing package instead, e.g. a published release.
#
# The host name (LDM_HOST_NAME, default sample.local) must resolve to this
# machine. Credentials for the API checks: LIFERAY_USER / LIFERAY_PASSWORD
# (default test@liferay.com / test).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=tools/lib/ldm.sh
source "${REPO_ROOT}/tools/lib/ldm.sh"

PROJECT_ID="e2e-boot"
# `--samples` requires a custom host name; with --no-ssl Liferay is served at
# http://<host>:8080, so the host must resolve here (CI adds it to /etc/hosts).
HOST_NAME="${LDM_HOST_NAME:-sample.local}"
BASE_URL="${LIFERAY_URL:-http://${HOST_NAME}:8080}"
AUTH="${LIFERAY_USER:-test@liferay.com}:${LIFERAY_PASSWORD:-test}"
WORK_DIR="$(mktemp -d)"
DIAG_DIR="${LDM_DIAG_DIR:-${WORK_DIR}/diagnostics}"

FAILED=0
fail() {
    echo "❌ $*"
    FAILED=1
}

if [ -z "${LIFERAY_ACTIVATION_KEY_XML:-}" ]; then
    echo "❌ ERROR: LIFERAY_ACTIVATION_KEY_XML is not set. An unlicensed portal never"
    echo "   deploys the site initializers, so there would be nothing to check."
    exit 1
fi

if ! getent hosts "$HOST_NAME" >/dev/null 2>&1 && ! ping -c1 -t1 "$HOST_NAME" >/dev/null 2>&1; then
    echo "❌ ERROR: ${HOST_NAME} does not resolve; add '127.0.0.1 ${HOST_NAME}' to /etc/hosts."
    exit 1
fi

if ! command -v ldm >/dev/null 2>&1 || [ "${LDM_FORCE_INSTALL:-}" = "1" ]; then
    install_ldm "${WORK_DIR}/bin"
fi
echo "🚀 Boot E2E for LDM Samples (LDM ${LDM_VERSION})"

# 1. The package.
if [ -n "${LDMP:-}" ]; then
    PACKAGE="$LDMP"
else
    LDM_BUILD_DIR="${WORK_DIR}/build" "${REPO_ROOT}/tools/build-ldmp.sh"
    PACKAGE="${REPO_ROOT}/ldm-cx-samples.ldmp"
fi
echo "📦 Package: ${PACKAGE} ($(du -h "$PACKAGE" | cut -f1))"

# 2. Point LDM at it as the samples root (see run-e2e.sh: LDM_SAMPLES_PATH
#    beats the cache and never downloads).
INSPECT_DIR="${WORK_DIR}/inspect"
SAMPLES_ROOT="${WORK_DIR}/samples"
mkdir -p "$INSPECT_DIR" "$SAMPLES_ROOT"
tar -xzf "$PACKAGE" -C "$INSPECT_DIR"
tar -xzf "${INSPECT_DIR}/files.tar.gz" -C "$SAMPLES_ROOT"
cp "${INSPECT_DIR}/meta" "${SAMPLES_ROOT}/meta"
export LDM_SAMPLES_PATH="$SAMPLES_ROOT"

PROJECT_DIR="${WORK_DIR}/${PROJECT_ID}"
cleanup() {
    local status=$?
    if [ "$status" -ne 0 ] || [ "$FAILED" -ne 0 ]; then
        echo "⚠️ Collecting diagnostics in ${DIAG_DIR}"
        mkdir -p "$DIAG_DIR"
        docker ps -a > "${DIAG_DIR}/containers.txt" 2>&1 || true
        docker logs --tail 2000 "$PROJECT_ID" > "${DIAG_DIR}/liferay.log" 2>&1 || true
        ls -laR "${PROJECT_DIR}/deploy" "${PROJECT_DIR}/osgi" "${PROJECT_DIR}/.ldm" \
            > "${DIAG_DIR}/project-dirs.txt" 2>&1 || true
        tail -n 150 "${DIAG_DIR}/liferay.log" || true
    fi
    ldm down "$PROJECT_ID" --non-interactive || true
    return "$status"
}
trap cleanup EXIT

# 3. Seed the project, stage the licence, boot, and wait for every deployable
#    (the site initializers deploy only once Liferay is healthy).
cd "$WORK_DIR"
docker network create liferay-net >/dev/null 2>&1 || true
ldm init "$PROJECT_ID" -y --samples --host-name "$HOST_NAME" --no-ssl
mkdir -p "${PROJECT_DIR}/deploy"
printf '%s' "$LIFERAY_ACTIVATION_KEY_XML" > "${PROJECT_DIR}/deploy/activation-key.xml"
ldm -y run "$PROJECT_ID" --fast-login
ldm wait "$PROJECT_ID" --non-interactive --wait-for-deployables

# 4. Check the sites through the portal itself.
echo "🔍 Checking the sites..."
api() { curl -fsS -u "$AUTH" "${BASE_URL}/api/jsonws/$1"; }

COMPANY_ID="$(api 'company/get-company-by-web-id?webId=liferay.com' |
    python3 -c 'import json,sys; print(json.load(sys.stdin)["companyId"])')"
GROUPS_JSON="${WORK_DIR}/groups.json"
api "group/get-groups?companyId=${COMPANY_ID}&parentGroupId=0&site=true" > "$GROUPS_JSON"
python3 -c 'import json,sys
for g in json.load(open(sys.argv[1])):
    print("  %s  %-16s %-24s %s" % (g["groupId"], g["externalReferenceCode"], g["friendlyURL"], g["groupKey"]))' "$GROUPS_JSON"

# check_site <site ERC> <theme CSS client extension ERC>
check_site() {
    local erc="$1" theme="$2" row group_id friendly layouts html
    row="$(python3 -c 'import json,sys
for g in json.load(open(sys.argv[1])):
    if g["externalReferenceCode"] == sys.argv[2]:
        print(g["groupId"], g["friendlyURL"])' "$GROUPS_JSON" "$erc")"
    if [ -z "$row" ]; then
        fail "site ${erc}: not found"
        return
    fi
    read -r group_id friendly <<< "$row"

    layouts="$(api "layout/get-layouts-count?groupId=${group_id}&privateLayout=false")"
    echo "  ${erc}: ${layouts} public pages"
    [ "${layouts:-0}" -ge 1 ] || fail "site ${erc}: no public pages; was the initializer applied?"

    if ! html="$(curl -fsS "${BASE_URL}/web${friendly}/home")"; then
        fail "site ${erc}: /web${friendly}/home did not load"
        return
    fi
    # FreeMarker that did not run, or a configuration the fragment never declared.
    if grep -qE '\[configuration\.|\$\{configuration' <<< "$html"; then
        fail "site ${erc}: unresolved fragment configuration on /web${friendly}/home: $(grep -oE '\[configuration\.[A-Za-z]*\]|\$\{configuration[^}]*\}' <<< "$html" | sort -u | tr '\n' ' ')"
    fi
    if grep -q "$theme" <<< "$html"; then
        echo "  ${erc}: /web${friendly}/home uses ${theme}"
    else
        fail "site ${erc}: /web${friendly}/home does not use the ${theme} theme CSS"
        echo "  Stylesheets on /web${friendly}/home:"
        grep -oE '<link[^>]*stylesheet[^>]*>' <<< "$html" | grep -oE 'href="[^"]*"' | sed 's/^/    /' || true
        echo "  Fragments rendered: $(grep -oE 'eco-hero|initiative-card|grid-monitor|impact-slider' <<< "$html" | sort -u | tr '\n' ' ')"
        echo "  Home page as Liferay sees it (headless-delivery):"
        curl -sS -u "$AUTH" "${BASE_URL}/o/headless-delivery/v1.0/sites/${group_id}/site-pages/home" |
            python3 -c 'import json,sys
try:
    d=json.load(sys.stdin)
except Exception as e:
    print("    (unreadable:", e, ")"); sys.exit()
pd=d.get("pageDefinition") or {}
print("    title:", d.get("title"), "| plid/id:", d.get("id"))
print("    settings:", json.dumps(pd.get("settings"), sort_keys=True))
print("    top-level elements:", [e.get("type") for e in (pd.get("pageElement") or {}).get("pageElements", [])])
if "status" in d or "title" not in d: print("    raw:", json.dumps(d)[:400])' || true
        echo "  Master pages in the site:"
        curl -sS -u "$AUTH" "${BASE_URL}/o/headless-admin-site/v1.0/sites/${erc}/master-pages?pageSize=50" |
            python3 -c 'import json,sys
try:
    d=json.load(sys.stdin)
except Exception as e:
    print("    (unreadable:", e, ")"); sys.exit()
items=d.get("items")
if items is None: print("    raw:", json.dumps(d)[:400]); sys.exit()
for e in items:
    print("    " + json.dumps({k: e.get(k) for k in ("name", "key", "externalReferenceCode")}))
if not items: print("    (none)")' || true
    fi
}
check_site ecopulse-site ecopulse-brand
check_site L_GUEST veridian-brand

# The impact slider renders the High Impact Initiatives asset list.
slider="$(curl -fsS "${BASE_URL}/web/ecopulse-smart-city/home" | python3 -c 'import re,sys
m = re.search(r"<div class=\"impact-slider.*?</div>\s*</div>\s*$|<div class=\"impact-slider.*", sys.stdin.read(), re.S)
if not m: print("missing"); sys.exit()
s = m.group(0)
print("%d cards" % s.count("card-title") if "card-title" in s else ("empty" if "No high-impact" in s else "broken"))')" || slider="unreachable"
case "$slider" in
    *cards) echo "  ✅ impact slider: ${slider}" ;;
    empty) echo "  ⚠️ impact slider renders but the asset list is empty" ;;
    *) fail "impact slider: ${slider}" ;;
esac

# 5. Check the content the initializers and ecopulse-batch should have added.
#    py <path> <python expression over d, the JSON reply> prints the expression,
#    or the HTTP error, so each check shows what Liferay actually returned.
py() {
    local path="$1" expr="$2" body
    body="$(curl -sS -u "$AUTH" -w '\n%{http_code}' "${BASE_URL}${path}" 2>&1)" || true
    python3 -c 'import json,sys
body, code = sys.argv[1].rsplit("\n", 1)
if code != "200":
    print("HTTP %s: %s" % (code, body[:300].replace("\n", " "))); sys.exit()
d = json.loads(body)
print(eval(sys.argv[2]))' "$body" "$expr"
}
# expect <label> <python condition over d> <path> <python expression shown>
expect() {
    local label="$1" cond="$2" path="$3" show="$4" ok
    ok="$(py "$path" "bool(${cond})")"
    if [ "$ok" = "True" ]; then
        echo "  ✅ ${label}: $(py "$path" "$show")"
    else
        fail "${label}: $(py "$path" "$show")"
    fi
}

echo "🔍 Checking objects..."
for object in ecopulse-energy-sector:energysectors ecopulse-green-initiative:greeninitiatives; do
    erc="${object%%:*}" rest="${object#*:}"
    expect "object ${erc}" 'd.get("status", {}).get("label") == "approved"' \
        "/o/object-admin/v1.0/object-definitions/by-external-reference-code/${erc}" \
        '(d.get("name"), d.get("className"), d.get("status"))'
    expect "entries /o/c/${rest}" 'd.get("totalCount", 0) >= 5' \
        "/o/c/${rest}?pageSize=50&fields=externalReferenceCode" \
        '(d.get("totalCount"), [e.get("externalReferenceCode") for e in d.get("items", [])])'
done
expect "workflow definition Machine Approver" 'any(e.get("name") == "Machine Approver" for e in d.get("items", []))' \
    "/o/headless-admin-workflow/v1.0/workflow-definitions?pageSize=50" \
    '[e.get("name") for e in d.get("items", [])]'
expect "high-impact initiatives tagged" 'len([e for e in d.get("items", []) if "high-impact" in (e.get("keywords") or [])]) >= 1' \
    "/o/c/greeninitiatives?pageSize=50" \
    '[(e.get("externalReferenceCode"), e.get("impactLevel"), e.get("keywords")) for e in d.get("items", [])]'

# check_content <site ERC> <navigation menu name>
check_content() {
    local erc="$1" menu="$2" group_id
    group_id="$(python3 -c 'import json,sys
for g in json.load(open(sys.argv[1])):
    if g["externalReferenceCode"] == sys.argv[2]: print(g["groupId"])' "$GROUPS_JSON" "$erc")"
    [ -n "$group_id" ] || return 0
    echo "🔍 Checking ${erc} content..."
    expect "${erc} navigation menu '${menu}'" \
        "any(m.get('name') == '${menu}' and m.get('navigationMenuItems') for m in d.get('items', []))" \
        "/o/headless-admin-site/v1.0/sites/${erc}/navigation-menus?pageSize=50" \
        '[(m.get("name"), [i.get("name") for i in m.get("navigationMenuItems") or []]) for m in d.get("items", [])]'
    expect "${erc} display page template" \
        'any("Energy Sector" in (t.get("name") or "") for t in d.get("items", []))' \
        "/o/headless-admin-site/v1.0/sites/${erc}/display-page-templates?pageSize=50" \
        '[(t.get("name"), (t.get("contentTypeReference") or {}).get("className")) for t in d.get("items", [])]'
    # The list exists once the initializer ran; it only returns entries once its
    # scope includes the Global site, which an initializer cannot set.
    expect "${erc} asset list high-impact-initiatives" '"totalCount" in d' \
        "/o/headless-delivery/v1.0/sites/${group_id}/content-sets/by-key/high-impact-initiatives/content-set-elements?pageSize=50" \
        '(d.get("totalCount"), [e.get("title") for e in d.get("items", [])])'
    expect "${erc} news articles" \
        'd.get("totalCount", 0) >= 7 and "[$" not in json.dumps(d)' \
        "/o/headless-delivery/v1.0/sites/${group_id}/structured-contents?pageSize=50&fields=title,contentFields" \
        '(d.get("totalCount"), sorted(set(__import__("re").findall(r"\[\$[A-Z_]+:[^$]*\$\]", json.dumps(d)))))'
}
check_content ecopulse-site "Main Navigation"
check_content L_GUEST "Veridian Main Navigation"

echo "🔍 Checking search blueprints..."
expect "search blueprints" \
    'all(any(b.get("externalReferenceCode") == e for b in d.get("items", [])) for e in ("ecopulse-gi-finder", "veridian-gi-finder"))' \
    "/o/search-experiences-rest/v1.0/sxp-blueprints?pageSize=50" \
    '[(b.get("externalReferenceCode"), b.get("title")) for b in d.get("items", [])]'

if [ "$FAILED" -ne 0 ]; then
    echo "❌ Boot E2E failed."
    exit 1
fi
echo "🎉 Boot E2E passed."

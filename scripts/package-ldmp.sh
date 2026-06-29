#!/bin/bash
# scripts/package-ldmp.sh
# Packages the LDM CX Samples environment into a standardized LDM package (.ldmp)
set -e

PROJECT_ID="ldm-cx-samples"
GIT_REPO="peterrichards-lr/ldm-cx-samples"
LIFERAY_TAG="2026.q1.4-lts"
DB_TYPE="postgresql"

echo "📦 Packaging LDM Environment for: ${PROJECT_ID}"
echo "--------------------------------------------------"

# Cross-platform SHA-256 helper
calculate_sha256() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    node -e "const crypto = require('crypto'); const fs = require('fs'); console.log(crypto.createHash('sha256').update(fs.readFileSync('$1')).digest('hex'));"
  fi
}

# 1. Create a temporary staging directory
STAGING_DIR="./ldm_staging"
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

# 2. Package database state (empty since samples are stateless and initialized via site initializer)
echo "💾 Generating empty database state..."
touch "${STAGING_DIR}/database.sql"

# 3. Package directory assets (client extensions and configs)
echo "📂 Archiving volume assets and deployments..."
FILES_STAGING="${STAGING_DIR}/files_staging"
mkdir -p "${FILES_STAGING}/deploy"
mkdir -p "${FILES_STAGING}/client-extensions"
mkdir -p "${FILES_STAGING}/osgi/configs"
mkdir -p "${FILES_STAGING}/osgi/portal-log4j"
mkdir -p "${FILES_STAGING}/files"
mkdir -p "${FILES_STAGING}/routes"

# Copy compiled client extension ZIPs from client-extensions/*/dist/*.zip
echo "📦 Staging Client Extension ZIPs..."
find client-extensions -name "*.zip" -path "*/dist/*" -exec cp -v {} "${FILES_STAGING}/client-extensions/" \; 2>/dev/null || true

# Copy compiled fragments ZIPs from fragments/*/dist/*.zip
echo "🧩 Staging Fragment ZIPs..."
if [ -d fragments ]; then
  find fragments -name "*.zip" -path "*/dist/*" -exec cp -v {} "${FILES_STAGING}/deploy/" \; 2>/dev/null || true
fi
# Also copy CX-style fragments if any
find client-extensions -name "*fragment*.zip" -path "*/dist/*" -exec cp -v {} "${FILES_STAGING}/deploy/" \; 2>/dev/null || true

# Copy OSGi Configurations
echo "⚙️ Staging OSGi configurations..."
if [ -d configs/common ]; then
  find configs/common -name "*.config" -o -name "*.cfg" -exec cp -v {} "${FILES_STAGING}/osgi/configs/" \; 2>/dev/null || true
fi
# Also scan other config directories if present
find client-extensions -name "*.config" -o -name "*.cfg" -exec cp -v {} "${FILES_STAGING}/osgi/configs/" \; 2>/dev/null || true

# Copy portal-ext.properties if exists
if [ -f portal-ext.properties ]; then
  cp -v portal-ext.properties "${FILES_STAGING}/files/"
elif [ -f configs/common/portal-ext.properties ]; then
  cp -v configs/common/portal-ext.properties "${FILES_STAGING}/files/"
fi

# Copy portal log4j if exists
if [ -d configs/common/portal-log4j ]; then
  cp -r configs/common/portal-log4j/* "${FILES_STAGING}/osgi/portal-log4j/" 2>/dev/null || true
fi

# Copy routes if exists
if [ -d routes ]; then
  cp -r routes/* "${FILES_STAGING}/routes/" 2>/dev/null || true
fi

# Archive files_staging into files.tar.gz
if [ "$(ls -A "${FILES_STAGING}" 2>/dev/null)" ]; then
  tar -czf "${STAGING_DIR}/files.tar.gz" -C "${FILES_STAGING}" .
  files_sha=$(calculate_sha256 "${STAGING_DIR}/files.tar.gz")
  echo "${files_sha}" > "${STAGING_DIR}/files.tar.gz.sha256"
  echo "✅ Staged files archived successfully."
else
  echo "⚠️ WARNING: No staged assets found. Creating empty volume assets."
  touch "${STAGING_DIR}/files.tar.gz"
  echo "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" > "${STAGING_DIR}/files.tar.gz.sha256"
fi

# 4. Generate manifest 'meta' file with dynamic metadata
echo "📄 Generating manifest 'meta' file..."
cx_list=""
if [ -d "${FILES_STAGING}/client-extensions" ]; then
  for f in "${FILES_STAGING}/client-extensions"/*; do
    if [ -f "$f" ]; then
      cx_list="${cx_list:+${cx_list},}$(basename "$f")"
    fi
  done
fi

modules_list=""
if [ -d "${FILES_STAGING}/deploy" ]; then
  for f in "${FILES_STAGING}/deploy"/*; do
    if [ -f "$f" ]; then
      modules_list="${modules_list:+${modules_list},}$(basename "$f")"
    fi
  done
fi

cat <<EOF > "${STAGING_DIR}/meta"
tag=${LIFERAY_TAG}
db_type=${DB_TYPE}
github_repository=${GIT_REPO}
includes_database=false
includes_volume_assets=true
includes_client_extensions=true
includes_osgi_modules=true
client_extensions=${cx_list}
osgi_modules=${modules_list}
active_services=liferay
EOF

rm -rf "${FILES_STAGING}"

# 5. Compress the staging directory into the final .ldmp package
echo "📦 Compressing staging directory into ${PROJECT_ID}.ldmp..."
tar -czf "${PROJECT_ID}.ldmp" -C "$STAGING_DIR" .

# 6. Generate the SHA-256 signature for the package
echo "🔒 Calculating SHA-256 signature..."
calculate_sha256 "${PROJECT_ID}.ldmp" > "${PROJECT_ID}.ldmp.sha256"

# Cleanup
rm -rf "$STAGING_DIR"

echo "--------------------------------------------------"
echo "✅ Package created successfully:"
echo "👉 ${PROJECT_ID}.ldmp"
echo "👉 ${PROJECT_ID}.ldmp.sha256"

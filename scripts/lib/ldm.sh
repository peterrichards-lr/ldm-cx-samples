#!/bin/bash
# scripts/lib/ldm.sh
# Shared LDM pin and installer for build-ldmp.sh and run-e2e.sh. Source it;
# don't run it.

# The LDM release that builds and tests the .ldmp. Bump it deliberately, as a
# reviewed change, so an LDM regression can't silently break this repo.
# Override for a one-off run with: LDM_VERSION=v2.27.0 ./scripts/run-e2e.sh
LDM_VERSION="${LDM_VERSION:-v2.26.16-pre.1}"
LDM_REPO="peterrichards-lr/liferay-docker-manager"

# Installs the pinned LDM release binary into $1 (default ./.ldm-bin) and puts
# it on PATH. pip is not a supported install path: LDM ships release binaries
# with a checksums.txt, and the download is verified against it.
install_ldm() {
    local bin_dir="${1:-$PWD/.ldm-bin}"
    local asset
    case "$(uname -s)-$(uname -m)" in
        Linux-*) asset="ldm-linux" ;;
        Darwin-arm64) asset="ldm-macos-arm64" ;;
        Darwin-*) asset="ldm-macos-x86_64" ;;
        *)
            echo "❌ ERROR: no LDM release binary for $(uname -s)-$(uname -m)"
            return 1
            ;;
    esac

    mkdir -p "$bin_dir"
    local base="https://github.com/${LDM_REPO}/releases/download/${LDM_VERSION}"
    echo "⚙️ Installing LDM ${LDM_VERSION} (${asset})..."
    curl -fsSL "${base}/${asset}" -o "${bin_dir}/${asset}"
    curl -fsSL "${base}/checksums.txt" -o "${bin_dir}/checksums.txt"

    local expected actual
    expected="$(awk -v f="$asset" '$2 == f {print $1}' "${bin_dir}/checksums.txt")"
    if command -v sha256sum >/dev/null 2>&1; then
        actual="$(sha256sum "${bin_dir}/${asset}" | awk '{print $1}')"
    else
        actual="$(shasum -a 256 "${bin_dir}/${asset}" | awk '{print $1}')"
    fi
    if [ -z "$expected" ] || [ "$expected" != "$actual" ]; then
        echo "❌ ERROR: checksum mismatch for ${asset} (expected '${expected}', got '${actual}')"
        return 1
    fi

    mv "${bin_dir}/${asset}" "${bin_dir}/ldm"
    chmod +x "${bin_dir}/ldm"
    export PATH="${bin_dir}:$PATH"
    ldm --version
}

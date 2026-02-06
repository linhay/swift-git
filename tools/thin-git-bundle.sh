#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

bundle_root="${1:-${REPO_ROOT}/Sources/SwiftGit/Resource/git-instance.bundle}"
arch="${2:-$(uname -m 2>/dev/null || echo arm64)}"

log() {
  echo "[thin-git-bundle] $*"
}

if [[ ! -d "${bundle_root}" ]]; then
  log "Bundle not found: ${bundle_root}"
  exit 1
fi

if ! command -v lipo >/dev/null 2>&1; then
  log "lipo not found; cannot thin binaries."
  exit 1
fi

thinned=0
skipped=0

while IFS= read -r -d '' candidate; do
  if ! file "${candidate}" | grep -q "Mach-O"; then
    continue
  fi

  info="$(lipo -info "${candidate}" 2>/dev/null || true)"
  if [[ "${info}" == *"Non-fat"* ]]; then
    skipped=$((skipped + 1))
    continue
  fi
  if [[ "${info}" != *"${arch}"* ]]; then
    log "Skipping ${candidate}; arch ${arch} not found."
    skipped=$((skipped + 1))
    continue
  fi

  mode="$(stat -f %A "${candidate}")"
  tmp="${candidate}.thin"
  lipo -thin "${arch}" "${candidate}" -output "${tmp}"
  mv "${tmp}" "${candidate}"
  chmod "${mode}" "${candidate}"
  thinned=$((thinned + 1))
done < <(find "${bundle_root}" -type f -perm -111 -print0)

log "Thinned ${thinned} binaries (skipped: ${skipped})."

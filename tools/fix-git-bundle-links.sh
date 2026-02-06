#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

bundle_root="${1:-${REPO_ROOT}/Sources/SwiftGit/Resource/git-instance.bundle}"

log() {
  echo "[fix-git-bundle-links] $*"
}

if [[ ! -d "${bundle_root}" ]]; then
  log "Bundle not found: ${bundle_root}"
  exit 1
fi

git_core_dir="${bundle_root}/libexec/git-core"
git_bin="${git_core_dir}/git"

if [[ ! -x "${git_bin}" ]]; then
  log "Missing ${git_bin}; nothing to fix."
  exit 1
fi

relinked=0
bin_relinked=0

while IFS= read -r -d '' candidate; do
  name="$(basename "${candidate}")"
  if [[ "${name}" == "git" ]]; then
    continue
  fi
  if [[ -L "${candidate}" ]]; then
    continue
  fi
  if cmp -s "${git_bin}" "${candidate}"; then
    rm -f "${candidate}"
    ln -s "git" "${git_core_dir}/${name}"
    relinked=$((relinked + 1))
  fi
done < <(find "${git_core_dir}" -maxdepth 1 -type f -name 'git-*' -print0)

bin_dir="${bundle_root}/bin"
if [[ -d "${bin_dir}" ]]; then
  while IFS= read -r -d '' candidate; do
    name="$(basename "${candidate}")"
    if [[ "${name}" == "git" ]]; then
      continue
    fi
    if [[ -L "${candidate}" ]]; then
      continue
    fi
    core_match="${git_core_dir}/${name}"
    if [[ -f "${core_match}" ]] && cmp -s "${core_match}" "${candidate}"; then
      rm -f "${candidate}"
      ln -s "../libexec/git-core/${name}" "${bin_dir}/${name}"
      bin_relinked=$((bin_relinked + 1))
    fi
  done < <(find "${bin_dir}" -maxdepth 1 -type f -print0)
fi

log "Optimized git links: ${relinked} git-core links, ${bin_relinked} bin links."

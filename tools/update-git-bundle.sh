#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

DEFAULT_BASE_URL="https://mirrors.edge.kernel.org/pub/software/scm/git"
DEFAULT_OUTPUT="${REPO_ROOT}/tools/git-bundle"
DEFAULT_ARCHS="arm64,x86_64"
DEFAULT_MACOS_DEPLOYMENT_TARGET="12.0"
DEFAULT_LFS_API_URL="https://api.github.com/repos/git-lfs/git-lfs/releases/latest"
DEFAULT_LFS_BASE_URL="https://github.com/git-lfs/git-lfs/releases/download"
DEFAULT_LFS_RAW_BASE_URL="https://raw.githubusercontent.com/git-lfs/git-lfs"

log() {
  echo "[update-git-bundle] $*"
}

die() {
  echo "[update-git-bundle] Error: $*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: tools/update-git-bundle.sh [options]

Options:
  --version <ver>     Specify the git version to build (e.g. 2.52.0).
  --output <dir>      Output directory (default: tools/git-bundle).
  --base-url <url>    Base URL for git source tarballs (default: kernel.org mirror).
  --archs <list>      Comma-separated arch list (default: arm64,x86_64).
  --force             Remove existing output bundle before writing.
  --include-contrib   Include contrib/ in the bundle (default: skip).
  --include-extras    Include optional GUI/web/perl/completion tools (default: skip).
  --lfs-version <ver> Specify git-lfs version (e.g. 3.5.0). Defaults to latest.
  --lfs-api-url <url> GitHub API URL for latest release metadata.
  --lfs-base-url <u>  Base URL for git-lfs release assets.
  --lfs-raw-base-url  Base URL for git-lfs raw files (README/CHANGELOG/install).
  --no-strip          Do not strip symbols from binaries.
  --skip-lfs          Do not copy existing git-lfs bundle from the repo.
  -h, --help          Show this help.

Notes:
  - This script builds Git from the official source tarball.
  - Output goes to <output>/git-instance.bundle by default.
  - git-lfs is downloaded from GitHub releases; if skipped, the existing bundle is reused.
EOF
}

optimize_git_links() {
  local bundle_root="$1"
  local git_core_dir="${bundle_root}/libexec/git-core"
  local git_bin="${git_core_dir}/git"
  local relinked=0
  local bin_relinked=0

  if [[ ! -x "${git_bin}" ]]; then
    log "Skipping link optimization; missing ${git_bin}"
    return
  fi

  if [[ -d "${git_core_dir}" ]]; then
    while IFS= read -r -d '' candidate; do
      local name
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
  fi

  local bin_dir="${bundle_root}/bin"
  if [[ -d "${bin_dir}" ]]; then
    while IFS= read -r -d '' candidate; do
      local name
      name="$(basename "${candidate}")"
      if [[ "${name}" == "git" ]]; then
        continue
      fi
      if [[ -L "${candidate}" ]]; then
        continue
      fi
      local core_match="${git_core_dir}/${name}"
      if [[ -f "${core_match}" ]] && cmp -s "${core_match}" "${candidate}"; then
        rm -f "${candidate}"
        ln -s "../libexec/git-core/${name}" "${bin_dir}/${name}"
        bin_relinked=$((bin_relinked + 1))
      fi
    done < <(find "${bin_dir}" -maxdepth 1 -type f -print0)
  fi

  if [[ "${relinked}" -gt 0 || "${bin_relinked}" -gt 0 ]]; then
    log "Optimized git links: ${relinked} git-core links, ${bin_relinked} bin links."
  fi
}

strip_bundle_binaries() {
  local bundle_root="$1"
  local stripped=0
  local skipped=0

  if ! command -v strip >/dev/null 2>&1; then
    log "strip not found; skipping symbol stripping."
    return
  fi

  while IFS= read -r -d '' candidate; do
    if file "${candidate}" | grep -q "Mach-O"; then
      if strip -S "${candidate}" 2>/dev/null; then
        stripped=$((stripped + 1))
      else
        skipped=$((skipped + 1))
      fi
    fi
  done < <(find "${bundle_root}" -type f -perm -111 -print0)

  log "Stripped ${stripped} binaries (skipped: ${skipped})."
}

prune_bundle_extras() {
  local bundle_root="$1"
  local share_dir="${bundle_root}/share"
  local bin_dir="${bundle_root}/bin"
  local core_dir="${bundle_root}/libexec/git-core"

  rm -rf "${share_dir}/git-gui" \
         "${share_dir}/gitk" \
         "${share_dir}/gitweb" \
         "${share_dir}/bash-completion" \
         "${share_dir}/perl5" 2>/dev/null || true

  rm -f "${bin_dir}/gitk" \
        "${bin_dir}/git-cvsserver" 2>/dev/null || true

  rm -f "${core_dir}/git-gui" \
        "${core_dir}/git-gui--askpass" \
        "${core_dir}/git-gui--askyesno" \
        "${core_dir}/git-instaweb" \
        "${core_dir}/git-send-email" \
        "${core_dir}/git-svn" \
        "${core_dir}/git-p4" \
        "${core_dir}/git-cvsserver" 2>/dev/null || true

  log "Pruned optional GUI/web/perl/completion tooling."
}

resolve_lfs_release() {
  local json
  json="$(curl -fsSL "${lfs_api_url}")"
  LFS_JSON="${json}" python3 - <<'PY'
import json
import os
import shlex

data = json.loads(os.environ["LFS_JSON"])
tag = data.get("tag_name", "").strip()
if not tag:
    raise SystemExit("missing tag_name in git-lfs release metadata")

assets = {a.get("name"): a.get("browser_download_url") for a in data.get("assets", [])}

arm_name = f"git-lfs-darwin-arm64-{tag}.zip"
amd_name = f"git-lfs-darwin-amd64-{tag}.zip"

arm_url = assets.get(arm_name, "")
amd_url = assets.get(amd_name, "")
arm_sha_url = assets.get(f"{arm_name}.sha256", "")
amd_sha_url = assets.get(f"{amd_name}.sha256", "")

print(f"lfs_tag={shlex.quote(tag)}")
print(f"lfs_arm_name={shlex.quote(arm_name)}")
print(f"lfs_amd_name={shlex.quote(amd_name)}")
print(f"lfs_arm_url={shlex.quote(arm_url)}")
print(f"lfs_amd_url={shlex.quote(amd_url)}")
print(f"lfs_arm_sha_url={shlex.quote(arm_sha_url)}")
print(f"lfs_amd_sha_url={shlex.quote(amd_sha_url)}")
PY
}

download_lfs_asset() {
  local name="$1"
  local url="$2"
  local sha_url="$3"
  local dest="${workdir}/${name}"
  local sha_dest="${dest}.sha256"

  if [[ -z "${url}" ]]; then
    die "Missing download URL for ${name}"
  fi

  log "Downloading git-lfs asset ${name}"
  curl -fL "${url}" -o "${dest}"

  if [[ -n "${sha_url}" ]]; then
    curl -fL "${sha_url}" -o "${sha_dest}"
    local expected
    expected="$(awk '{print $1}' "${sha_dest}" | head -n 1)"
    if [[ -z "${expected}" ]]; then
      die "Missing checksum for ${name}"
    fi

    local actual
    actual="$(shasum -a 256 "${dest}" | awk '{print $1}')"
    if [[ "${expected}" != "${actual}" ]]; then
      die "SHA256 mismatch for ${name}"
    fi
  else
    log "No checksum asset found for ${name}; recording computed SHA256."
    sha_dest="${dest}.sha256"
    shasum -a 256 "${dest}" > "${sha_dest}"
  fi
}

version=""
output="${DEFAULT_OUTPUT}"
base_url="${DEFAULT_BASE_URL}"
archs="${DEFAULT_ARCHS}"
force=0
include_contrib=0
include_extras=0
skip_lfs=0
strip_binaries=1
lfs_version=""
lfs_api_url="${DEFAULT_LFS_API_URL}"
lfs_base_url="${DEFAULT_LFS_BASE_URL}"
lfs_raw_base_url="${DEFAULT_LFS_RAW_BASE_URL}"
lfs_tag=""
lfs_version_resolved=""
lfs_sha_arm64=""
lfs_sha_amd64=""
lfs_source=""
lfs_arm_name=""
lfs_amd_name=""
lfs_arm_url=""
lfs_amd_url=""
lfs_arm_sha_url=""
lfs_amd_sha_url=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      version="${2:-}"
      shift 2
      ;;
    --output)
      output="${2:-}"
      shift 2
      ;;
    --base-url)
      base_url="${2:-}"
      shift 2
      ;;
    --archs)
      archs="${2:-}"
      shift 2
      ;;
    --force)
      force=1
      shift
      ;;
    --include-contrib)
      include_contrib=1
      shift
      ;;
    --include-extras)
      include_extras=1
      shift
      ;;
    --no-strip)
      strip_binaries=0
      shift
      ;;
    --lfs-version)
      lfs_version="${2:-}"
      shift 2
      ;;
    --lfs-api-url)
      lfs_api_url="${2:-}"
      shift 2
      ;;
    --lfs-base-url)
      lfs_base_url="${2:-}"
      shift 2
      ;;
    --lfs-raw-base-url)
      lfs_raw_base_url="${2:-}"
      shift 2
      ;;
    --skip-lfs)
      skip_lfs=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown argument: $1"
      ;;
  esac
done

for cmd in curl tar shasum make clang awk grep sed; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    die "Required command not found: $cmd"
  fi
done

if [[ "${skip_lfs}" -eq 0 ]]; then
  for cmd in python3 unzip; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      die "Required command not found for git-lfs: $cmd"
    fi
  done
fi

if [[ -z "${version}" ]]; then
  log "Resolving latest stable version from ${base_url}"
  index="$(curl -fsSL "${base_url}/")"
  version="$(
    echo "$index" \
      | grep -Eo 'git-[0-9]+\.[0-9]+\.[0-9]+\.tar\.xz' \
      | sed -E 's/^git-|\.tar\.xz$//g' \
      | sort -t. -k1,1n -k2,2n -k3,3n \
      | tail -n 1
  )"
  if [[ -z "${version}" ]]; then
    die "Unable to determine the latest version. Use --version to specify one."
  fi
fi

tarball="git-${version}.tar.xz"
workdir="$(mktemp -d "${TMPDIR:-/tmp}/git-bundle.XXXXXX")"
trap 'rm -rf "${workdir}"' EXIT

log "Downloading ${tarball}"
curl -fL "${base_url}/${tarball}" -o "${workdir}/${tarball}"

log "Fetching SHA256 checksums"
curl -fL "${base_url}/sha256sums.asc" -o "${workdir}/sha256sums.asc"

expected_sha="$(grep " ${tarball}$" "${workdir}/sha256sums.asc" | head -n 1 | awk '{print $1}')"
if [[ -z "${expected_sha}" ]]; then
  die "Checksum not found for ${tarball} in sha256sums.asc"
fi

actual_sha="$(shasum -a 256 "${workdir}/${tarball}" | awk '{print $1}')"
if [[ "${expected_sha}" != "${actual_sha}" ]]; then
  die "SHA256 mismatch for ${tarball}"
fi

log "Extracting ${tarball}"
tar -xf "${workdir}/${tarball}" -C "${workdir}"

src_dir="${workdir}/git-${version}"
stage_dir="${workdir}/stage"

if [[ ! -d "${src_dir}" ]]; then
  die "Source directory not found: ${src_dir}"
fi

mkdir -p "${stage_dir}"

arch_flags=""
IFS=',' read -r -a arch_list <<< "${archs}"
for arch in "${arch_list[@]}"; do
  if [[ -n "${arch}" ]]; then
    arch_flags="${arch_flags} -arch ${arch}"
  fi
done
arch_flags="${arch_flags# }"

export CC="clang"
export CFLAGS="${arch_flags} -O2"
export LDFLAGS="${arch_flags}"
export MACOSX_DEPLOYMENT_TARGET="${DEFAULT_MACOS_DEPLOYMENT_TARGET}"

make_vars=(
  "CC=${CC}"
  "CFLAGS=${CFLAGS}"
  "LDFLAGS=${LDFLAGS}"
  "NO_GETTEXT=1"
)

if ! command -v tclsh >/dev/null 2>&1; then
  log "tclsh not found; building without Tcl/Tk (gitk will be omitted)."
  make_vars+=("NO_TCLTK=1")
fi

jobs="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"

pushd "${src_dir}" >/dev/null
  if [[ ! -x "./configure" ]]; then
    log "Generating configure script"
    make configure
  fi

  log "Configuring build"
  ./configure --prefix="${stage_dir}"

  log "Building (jobs: ${jobs})"
  make -j"${jobs}" "${make_vars[@]}"

  log "Installing to staging"
  make install "${make_vars[@]}"
popd >/dev/null

osxkeychain_dir="${src_dir}/contrib/credential/osxkeychain"
if [[ -d "${osxkeychain_dir}" ]]; then
  log "Building git-credential-osxkeychain"
  osx_cflags="${CFLAGS} -I${src_dir} -DNO_OPENSSL"
  osx_cppflags="-I${src_dir} -DNO_OPENSSL"
  osx_ldflags="${LDFLAGS} -lz -liconv"
  if make -C "${osxkeychain_dir}" \
      "CC=${CC}" \
      "CFLAGS=${osx_cflags}" \
      "CPPFLAGS=${osx_cppflags}" \
      "LDFLAGS=${osx_ldflags}" \
      "LIBS=-lz -liconv"; then
    if [[ -f "${osxkeychain_dir}/git-credential-osxkeychain" ]]; then
      cp "${osxkeychain_dir}/git-credential-osxkeychain" "${stage_dir}/bin/"
    fi
  else
    log "Failed to build git-credential-osxkeychain; attempting to reuse existing binary."
    existing_keychain="${REPO_ROOT}/Sources/SwiftGit/Resource/git-instance.bundle/bin/git-credential-osxkeychain"
    if [[ -f "${existing_keychain}" ]]; then
      cp "${existing_keychain}" "${stage_dir}/bin/"
      log "Reused existing git-credential-osxkeychain binary."
    else
      log "No existing git-credential-osxkeychain found; continuing without it."
    fi
  fi
fi

bundle_dir="${output}/git-instance.bundle"
if [[ -e "${bundle_dir}" ]]; then
  if [[ "${force}" -eq 1 ]]; then
    rm -rf "${bundle_dir}"
  else
    die "Output bundle already exists: ${bundle_dir} (use --force to overwrite)"
  fi
fi

mkdir -p "${bundle_dir}"

if command -v rsync >/dev/null 2>&1; then
  rsync -aH "${stage_dir}/" "${bundle_dir}/"
else
  log "rsync not found; using tar to preserve hardlinks."
  (cd "${stage_dir}" && tar -cf - .) | (cd "${bundle_dir}" && tar -xpf -)
fi

if [[ "${include_contrib}" -eq 1 && -d "${src_dir}/contrib" ]]; then
  rm -rf "${bundle_dir}/contrib"
  cp -R "${src_dir}/contrib" "${bundle_dir}/"
fi

optimize_git_links "${bundle_dir}"

if [[ "${include_extras}" -eq 0 ]]; then
  prune_bundle_extras "${bundle_dir}"
fi

if [[ "${strip_binaries}" -eq 1 ]]; then
  strip_bundle_binaries "${bundle_dir}"
fi

if [[ "${skip_lfs}" -eq 0 ]]; then
  if [[ -n "${lfs_version}" ]]; then
    if [[ "${lfs_version}" == v* ]]; then
      lfs_tag="${lfs_version}"
    else
      lfs_tag="v${lfs_version}"
    fi
    lfs_api_url="https://api.github.com/repos/git-lfs/git-lfs/releases/tags/${lfs_tag}"
  fi

  log "Resolving git-lfs release from ${lfs_api_url}"
  eval "$(resolve_lfs_release)"

  if [[ -z "${lfs_tag}" || -z "${lfs_arm_url}" || -z "${lfs_amd_url}" ]]; then
    die "Missing git-lfs release assets from ${lfs_api_url}"
  fi

  lfs_version_resolved="${lfs_tag#v}"
  lfs_source="${lfs_base_url}/${lfs_tag}"

  download_lfs_asset "${lfs_arm_name}" "${lfs_arm_url}" "${lfs_arm_sha_url}"
  download_lfs_asset "${lfs_amd_name}" "${lfs_amd_url}" "${lfs_amd_sha_url}"

  lfs_sha_arm64="$(awk '{print $1}' "${workdir}/${lfs_arm_name}.sha256" | head -n 1)"
  lfs_sha_amd64="$(awk '{print $1}' "${workdir}/${lfs_amd_name}.sha256" | head -n 1)"

  lfs_arm_dir="${workdir}/git-lfs-arm64"
  lfs_amd_dir="${workdir}/git-lfs-amd64"
  mkdir -p "${lfs_arm_dir}" "${lfs_amd_dir}"
  unzip -q "${workdir}/${lfs_arm_name}" -d "${lfs_arm_dir}"
  unzip -q "${workdir}/${lfs_amd_name}" -d "${lfs_amd_dir}"

  lfs_arm_bin="$(find "${lfs_arm_dir}" -type f -name git-lfs | head -n 1 || true)"
  lfs_amd_bin="$(find "${lfs_amd_dir}" -type f -name git-lfs | head -n 1 || true)"
  if [[ -z "${lfs_arm_bin}" || -z "${lfs_amd_bin}" ]]; then
    die "Unable to locate git-lfs binaries in release archives"
  fi

  lfs_out="${bundle_dir}/git-lfs"
  rm -rf "${lfs_out}"
  mkdir -p "${lfs_out}"

  if command -v lipo >/dev/null 2>&1; then
    lipo -create "${lfs_arm_bin}" "${lfs_amd_bin}" -output "${lfs_out}/git-lfs"
  else
    log "lipo not found; selecting git-lfs for current arch only."
    if [[ "$(uname -m)" == "arm64" ]]; then
      cp "${lfs_arm_bin}" "${lfs_out}/git-lfs"
    else
      cp "${lfs_amd_bin}" "${lfs_out}/git-lfs"
    fi
  fi
  chmod +x "${lfs_out}/git-lfs"

  for doc in README.md CHANGELOG.md install.sh; do
    if [[ -f "${lfs_arm_dir}/${doc}" ]]; then
      cp "${lfs_arm_dir}/${doc}" "${lfs_out}/${doc}"
    elif [[ -f "${lfs_amd_dir}/${doc}" ]]; then
      cp "${lfs_amd_dir}/${doc}" "${lfs_out}/${doc}"
    fi
  done

  existing_lfs="${REPO_ROOT}/Sources/SwiftGit/Resource/git-instance.bundle/git-lfs"
  for doc in README.md CHANGELOG.md install.sh; do
    if [[ ! -f "${lfs_out}/${doc}" ]]; then
      raw_url="${lfs_raw_base_url}/${lfs_tag}/${doc}"
      if curl -fsSL "${raw_url}" -o "${lfs_out}/${doc}"; then
        continue
      fi
      if [[ -f "${existing_lfs}/${doc}" ]]; then
        cp "${existing_lfs}/${doc}" "${lfs_out}/${doc}"
      fi
    fi
  done
else
  existing_lfs="${REPO_ROOT}/Sources/SwiftGit/Resource/git-instance.bundle/git-lfs"
  if [[ -d "${existing_lfs}" ]]; then
    log "Copying existing git-lfs bundle (skipped update)"
    rm -rf "${bundle_dir}/git-lfs"
    cp -R "${existing_lfs}" "${bundle_dir}/"
  else
    log "No existing git-lfs bundle found; skipping."
  fi
fi

if [[ ! -x "${bundle_dir}/bin/git" ]]; then
  die "Generated bundle is missing bin/git"
fi

log "Verifying bundle: ${bundle_dir}/bin/git --version"
"${bundle_dir}/bin/git" --version

mkdir -p "${output}"
build_time="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
cat > "${output}/metadata.json" <<EOF
{
  "git_version": "${version}",
  "source": "${base_url}/${tarball}",
  "sha256": "${expected_sha}",
  "archs": "${archs}",
  "macos_deployment_target": "${DEFAULT_MACOS_DEPLOYMENT_TARGET}",
  "built_at": "${build_time}",
  "git_lfs_version": "${lfs_version_resolved}",
  "git_lfs_source": "${lfs_source}",
  "git_lfs_sha256_arm64": "${lfs_sha_arm64}",
  "git_lfs_sha256_amd64": "${lfs_sha_amd64}"
}
EOF
echo "${version}" > "${output}/VERSION"

log "Bundle generated at ${bundle_dir}"
log "Metadata written to ${output}/metadata.json"

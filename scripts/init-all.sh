#!/bin/bash

die() {
  local _ret="${2:-1}"
  echo "$1" >&2
  exit "${_ret}"
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || die "Couldn't determine the script's running directory, which probably matters, bailing out" 2

init-dir() {
  pushd "$1" >/dev/null && terraform init --backend=false
  popd >/dev/null || return
}

dirlist=$(find "${script_dir}/.." -type d \( -name .terraform -o -name .git -o -name .github  \) -prune -false -o -name '*.tf' -exec dirname {} \; | sort -u)

for dir in ${dirlist}; do
  [ -d "$dir" ] || break
  init-dir "$dir" &
done

wait
echo "Terraform initialization complete."

#!/bin/bash

die() {
  local _ret="${2:-1}"
  echo "$1" >&2
  exit "${_ret}"
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || die "Couldn't determine the script's running directory, which probably matters, bailing out" 2
pushd "${script_dir}/.." >/dev/null || die "Couldnt cd to root project directory" 2
find . -type d -name ".terraform" -print0 | xargs -0 rm -r
find . -type f -name ".terraform.lock.hcl" -print0 | xargs -0 rm
popd >/dev/null || return
echo "Removed all terraform initialization directories and lock files."

#!/bin/bash

die() {
  local _ret="${2:-1}"
  echo "$1" >&2
  exit "${_ret}"
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || die "Couldn't determine the script's running directory, which probably matters, bailing out" 2

pushd "${script_dir}/.." >/dev/null || die "Couldnt cd to root project directory" 2
if [[ -f context.tf ]]; then
  echo "Discovered existing context.tf! Fetching most recent version to see if there is an update."
  curl -o context.tf -fsSL https://raw.githubusercontent.com/cloudposse/terraform-null-label/master/exports/context.tf
  if git diff --no-patch --exit-code context.tf; then
    echo "No changes detected! Exiting the job..."
  else
    echo "context.tf file has changed. Updating all tracked versions of the file."
    for sub_context in $(git ls-files -- **/context.tf); do
      cp -p context.tf "$sub_context"
    done
    git ls-files --modified | xargs git add
  fi
else
  echo "This module has not yet been updated to support the context.tf pattern! Please update in order to support automatic updates."
fi

popd >/dev/null || return

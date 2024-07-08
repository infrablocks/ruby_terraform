#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -e
set -o pipefail

function ensure-asdf-plugin() {
  local name="$1"
  local repo="$2"

  if ! asdf plugin list | grep -q "$name"; then
    asdf plugin add "$name" "$repo"
  fi
}

ensure-asdf-plugin "ruby" "https://github.com/asdf-vm/asdf-ruby.git"
ensure-asdf-plugin "java" "https://github.com/halcyon/asdf-java.git"
ensure-asdf-plugin "golang" "https://github.com/asdf-community/asdf-golang.git"

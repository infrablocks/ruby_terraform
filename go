#!/usr/bin/env bash

[ -n "$GO_DEBUG" ] && set -x
set -e

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

verbose="no"
offline="no"
skip_checks="no"

missing_dependency="no"

[ -n "$GO_DEBUG" ] && verbose="yes"
[ -n "$GO_SKIP_CHECKS" ] && skip_checks="yes"
[ -n "$GO_OFFLINE" ] && offline="yes"

function loose_version() {
  local version="$1"

  IFS="." read -r -a version_parts <<<"$version"

  echo "${version_parts[0]}.${version_parts[1]}"
}

ruby_full_version="$(cat "$project_dir"/.ruby-version)"
ruby_loose_version="$(loose_version "$ruby_full_version")"

if [[ "$skip_checks" == "no" ]]; then
echo "Checking for system dependencies."
  if ! type ruby >/dev/null 2>&1 || ! ruby -v | grep -q "$ruby_loose_version"; then
    echo "This codebase requires Ruby $ruby_loose_version."
    missing_dependency="yes"
  fi

  if ! type bundler >/dev/null 2>&1; then
    echo "This codebase requires Bundler."
    missing_dependency="yes"
  fi

  if [[ "$missing_dependency" = "yes" ]]; then
    echo "Please install missing dependencies to continue."
    exit 1
  fi

  echo "All system dependencies present. Continuing."
fi

if [[ "$offline" == "no" ]]; then
  echo "Installing bundler."
  if [[ "$verbose" == "yes" ]]; then
    gem install --no-document bundler
  else
    gem install --no-document bundler >/dev/null
  fi

  echo "Installing ruby dependencies."
  if [[ "$verbose" == "yes" ]]; then
    bundle install
  else
    bundle install >/dev/null
  fi
fi

echo "Starting rake."
if [[ "$verbose" == "yes" ]]; then
  time bundle exec rake --verbose "$@"
else
  time bundle exec rake "$@"
fi

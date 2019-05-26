#!/usr/bin/env bash

[ -n "$GO_DEBUG" ] && set -x
set -e

project_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

verbose="no"
skip_checks="no"
offline="no"

missing_dependency="no"

[ -n "$GO_DEBUG" ] && verbose="yes"
[ -n "$GO_SKIP_CHECKS" ] && skip_checks="yes"
[ -n "$GO_OFFLINE" ] && offline="yes"


if [[ "$skip_checks" = "no" ]]; then
    echo "Checking for system dependencies."
    ruby_version="$(cat "$project_dir"/.ruby-version)"
    if ! type ruby >/dev/null 2>&1 || ! ruby -v | grep -q "$ruby_version"; then
        echo "This codebase requires Ruby $ruby_version."
        missing_dependency="yes"
    fi

    if [[ "$missing_dependency" = "yes" ]]; then
        echo "Please install missing dependencies to continue."
        exit 1
    fi

    echo "All system dependencies present. Continuing."
fi

if [[ "$offline" = "no" ]]; then
    echo "Installing bundler."
    if [[ "$verbose" = "yes" ]]; then
        gem install --no-document bundler
    else
        gem install --no-document bundler > /dev/null
    fi

    echo "Installing ruby dependencies."
    if [[ "$verbose" = "yes" ]]; then
        bundle install
    else
        bundle install > /dev/null
    fi
fi

echo "Starting rake."
if [[ "$verbose" = "yes" ]]; then
    time bundle exec rake --verbose "$@"
else
    time bundle exec rake "$@"
fi

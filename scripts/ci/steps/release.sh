#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -e
set -o pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/../../.." && pwd )"

cd "$PROJECT_DIR"

set +e
openssl aes-256-cbc \
    -d \
    -in ./.circleci/gpg.private.enc -k "${ENCRYPTION_PASSPHRASE}" | gpg --import -
set -e

git crypt unlock

git config --global user.email "circleci@infrablocks.io"
git config --global user.name "Circle CI"

mkdir -p ~/.gem
cp config/secrets/rubygems/credentials ~/.gem/credentials
chmod 0600 ~/.gem/credentials

./go version:bump[minor]
./go release

git status
git push

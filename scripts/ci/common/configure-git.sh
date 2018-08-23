#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -e
set -o pipefail

git config --global user.email "circleci@infrablocks.io"
git config --global user.name "Circle CI"

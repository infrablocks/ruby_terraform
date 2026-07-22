#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -e
set -o pipefail

sudo apt-get update
sudo apt-get install -y --no-install-recommends git-crypt gnupg

#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -e
set -o pipefail

GIT_CRYPT_VERSION="0.5.0"

apt-get update
apt-get install -y --no-install-recommends git ssh

for key in \
  EF5D84C1838F2EB6D8968C0410378EFC2080080C \
; do \
  gpg --verbose --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
done

curl -SLO "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-$GIT_CRYPT_VERSION.tar.gz"
curl -SLO "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-$GIT_CRYPT_VERSION.tar.gz.asc"
gpg --batch --verify "git-crypt-$GIT_CRYPT_VERSION.tar.gz.asc" "git-crypt-$GIT_CRYPT_VERSION.tar.gz"

mkdir -p /usr/src/git-crypt
tar -xzf "git-crypt-$GIT_CRYPT_VERSION.tar.gz" -C /usr/src/git-crypt --strip-components=1
rm "git-crypt-$GIT_CRYPT_VERSION.tar.gz"

cd /usr/src/git-crypt
make
make install

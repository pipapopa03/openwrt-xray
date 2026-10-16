#!/bin/sh
# usage: ./update.sh 26.9.30
set -e
version=$1
[ -n "$version" ] || { echo "usage: $0 <xray-version>"; exit 1; }
sha=$(curl -sfL "https://codeload.github.com/XTLS/Xray-core/tar.gz/v${version}" | sha256sum | awk '{print $1}')
sed -i "s/^PKG_VERSION.*/PKG_VERSION:=${version}/; s/^PKG_HASH.*/PKG_HASH:=${sha}/" Makefile
grep -E '^PKG_(VERSION|HASH)' Makefile

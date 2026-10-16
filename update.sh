#!/bin/sh
# usage: ./update.sh 26.10.10  — обновляет PKG_VERSION и PKG_HASH в Makefile
set -e
version=$1
[ -n "$version" ] || { echo "usage: $0 <xray-version>"; exit 1; }
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
curl -sfL -o "$tmp" "https://codeload.github.com/XTLS/Xray-core/tar.gz/v${version}"
tar -tzf "$tmp" >/dev/null   # проверка, что архив целый
sha=$(sha256sum "$tmp" | awk '{print $1}')
sed -i "s/^PKG_VERSION.*/PKG_VERSION:=${version}/; s/^PKG_HASH.*/PKG_HASH:=${sha}/" Makefile
grep -E '^PKG_(VERSION|HASH)' Makefile

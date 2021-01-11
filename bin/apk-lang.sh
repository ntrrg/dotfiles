#!/bin/sh
# Copyright (c) 2021 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

PACKAGES="${@:-"$(apk info | sort)"}"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	BIN_NAME="$(basename "$0")"

	cat << EOF
$BIN_NAME - find language packages.

Usage: $BIN_NAME [PACKAGE]...

Find language packages for given packages, if no packages are given, the full
list of installed packages will be used.

Options:
  -h, --help   Show this help message

Copyright (c) 2021 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

	exit
fi

ALL_PKGS="$(apk search "*")"

for PKG in $PACKAGES; do
	PKG_LANG="$PKG-lang"

	if echo "$ALL_PKGS" | grep -q "^$PKG_LANG-\d"; then
		echo "$PKG_LANG"
	fi
done

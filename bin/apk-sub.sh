#!/bin/sh
# Copyright (c) 2021 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

PACKAGES="${@:-"$(apk info | sort)"}"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	BIN_NAME="$(basename "$0")"

	cat << EOF
$BIN_NAME - find Alpine subpackages.

Usage: $BIN_NAME -s SUFFIX [PACKAGE]...

Find subpackages for given packages, if no packages are given, the full list of
installed packages will be used.

Options:
  -s, --suffix=SUFFIX   Look for subpackages with the given suffix
  -h, --help            Show this help message

Copyright (c) 2021 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

	exit
fi

if [ -z "$1" ]; then
	echo "no suffix provided" > "/dev/stderr"
	exit 1
fi

SUFFIX="$1"
ALL_PKGS="$(apk search "*")"

for PKG in $PACKAGES; do
	SUBPKG="$PKG-$SUFFIX"

	if echo "$ALL_PKGS" | grep -q "^$SUBPKG-\d"; then
		echo "$SUBPKG"
	fi
done

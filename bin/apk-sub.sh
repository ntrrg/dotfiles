#!/bin/sh
# Copyright (c) 2021 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	BIN_NAME="$(basename "$0")"

	cat << EOF
$BIN_NAME - find Alpine subpackages.

Usage: $BIN_NAME SUFFIX [PACKAGE]...

Find subpackages for given packages with the given suffix, if no packages are
given, the full list of installed packages will be used.

Options:
  -h, --help            Show this help message

Copyright (c) 2021 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

	exit
fi

if [ $# -eq 0 ]; then
	echo "no suffix provided" > "/dev/stderr"
	exit 1
fi

SUFFIX="$1"
shift

ALL_PKGS="$(apk search "*")"
PKGS="${@:-"$(apk info | sort)"}"

for PKG in $PKGS; do
	SUBPKG="$PKG-$SUFFIX"

	if echo "$ALL_PKGS" | grep -q "^$SUBPKG-\d"; then
		echo "$SUBPKG"
	fi
done

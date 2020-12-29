#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	BIN_NAME="$(basename "$0")"

	cat << EOF
$BIN_NAME - get the dependencies from the given packages.

Usage: $BIN_NAME PACKAGE...

Options:
  -h, --help   Show this help message

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

	exit
fi

apt-cache depends \
	--recurse --no-recommends --no-suggests --no-conflicts \
	--no-breaks --no-replaces --no-enhances -qq "$@" |
	tr -d " " |
	grep "^\(Pre\)\?Depends:" |
	sed "s/\(Pre\)\?Depends://" |
	grep "^\w" |
	sort -u

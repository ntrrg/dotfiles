#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	apt-cache depends \
		--recurse --no-recommends --no-suggests --no-conflicts \
		--no-breaks --no-replaces --no-enhances -qq "$@" |
		tr -d " " |
		grep "^\(Pre\)\?Depends:" |
		sed "s/\(Pre\)\?Depends://" |
		grep "^\w" |
		uniq
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - get the dependencies from the given packages.

Usage: $_name PACKAGE...

Options:
  -h, --help   Show this help message

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

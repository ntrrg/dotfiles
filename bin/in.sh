#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eo pipefail

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	if [ $# -eq 0 ]; then
		echo "no value provided" > /dev/stderr
		return 1
	fi

	local _val="$1"
	shift

	if [ $# -eq 0 ]; then
		eval set -- "$(cat -)"
	fi

	local _el=""

	for _el in "$@"; do
		if [ "$_val" = "$_el" ]; then
			return
		fi
	done

	return 1
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - check if a value is in the given set.

Usage: $_name [OPTIONS] -- VALUE [SET_ELEMENT...]

If no set elements are given, STDIN will be used.

Options:
  -h, --help    Show this help message

Bugs:
  * Space separated words from STDIN are parsed as different set elements.

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

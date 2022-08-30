#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	local _val="$1"

	if [ $# -eq 0 ]; then
		_val="$(cat -)"
	fi

	_val="$(echo "$_val" | tr '[:upper:]' '[:lower:]')"
	in.sh "$_val" "0" "false" "n" "no" "off"
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - check if the given value is falsy.

Usage: $_name [VALUE]

If no value is given, STDIN will be used.

Options:
  -h, --help   Show this help message

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

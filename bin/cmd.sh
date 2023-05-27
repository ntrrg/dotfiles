#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

_DRY_RUN="${DRY_RUN:-0}"

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	if [ "$1" = "-n" ] || [ "$1" = "--dry-run" ]; then
		_DRY_RUN=1
		shift
	fi

	printf "> $*\n" > "/dev/stderr"

	if is-falsy.sh "$_DRY_RUN"; then
		"$@"
	fi
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - execute a command and print what would be executed.

Usage: $_name [OPTIONS] COMMAND [ARGS]

Options:
  -n, --dry-run   Do not execute, just print
  -h, --help      Show this help message

Environment variables:
  * 'DRY_RUN' determines if the given command will be printed, but not
    executed. ($_DRY_RUN)

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

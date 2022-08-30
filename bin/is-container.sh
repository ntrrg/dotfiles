#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

_IS_CONTAINER=${IS_CONTAINER:-0}

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	if [ "$1" = "-y" ] || [ "$1" = "--yes" ]; then
		_IS_CONTAINER=1
	fi

	if is-truthy.sh "$_IS_CONTAINER" ||
		cat /proc/self/cgroup | grep -q "/docker" ||
		cat /proc/self/cgroup | grep -q "/kubepods" ||
		ischroot; then
		return
	fi

	return 1
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - check if the running system is a container.

Usage: $_name [OPTIONS]

Options:
  -h, --help   Show this help message.
  -y, --yes    Force status 0 exit.

Environment variables:
  * 'IS_CONTAINER' forces this program to exit with status 0 if its value is
    truthy. ($_IS_CONTAINER)

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

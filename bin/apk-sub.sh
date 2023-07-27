#!/bin/sh
# Copyright (c) 2021 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eo pipefail

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	if [ $# -eq 0 ]; then
		log.sh -f "no suffix provided"
	fi

	local _suffix="$1"
	shift

	local _all="$(apk search "*")"
	local _pkgs="$@"

	if [ -z "$_pkgs" ]; then
		_pkgs="$(apk info | sort | grep -v "\-$_suffix\$")"
	fi

	local _pkg=""

	for _pkg in $_pkgs; do
		local _subpkg="$_pkg-$_suffix"

		if echo "$_all" | grep -q "^$_subpkg-\d"; then
			echo "$_subpkg"
		fi
	done
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - find Alpine subpackages.

Usage: $_name SUFFIX [PACKAGE]...

Find subpackages for given packages with the given suffix, if no packages are
specified, installed packages will be used.

Options:
  -h, --help   Show this help message

For logging options see 'log.sh --help'.

Copyright (c) 2021 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

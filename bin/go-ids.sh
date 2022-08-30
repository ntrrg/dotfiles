#!/bin/sh
# Copyright (c) 2020 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eu

_GO="${GO:-"go"}"
_PRINT_TYPES=0
_PRINT_IFACES=0
_PRINT_FUNCS=0
_SHORT=0

command -v "$_GO" > "/dev/null" ||
	(
		echo "can't find go toolchain" > "/dev/stderr"
		exit 1
	)

_main() {
	local _opts="fhist"
	local _lopts="funcs,help,ifaces,short,types"

	eval set -- "$(
		getopt --options "$_opts" --longoptions "$_lopts" --name "$0" -- "$@"
	)"

	while [ $# -gt 0 ]; do
		case $1 in
		-h | --help)
			_show_help
			return
			;;

		-f | --funcs)
			_PRINT_TYPES=0
			_PRINT_IFACES=0
			_PRINT_FUNCS=1
			;;

		-i | --ifaces)
			_PRINT_TYPES=1
			_PRINT_IFACES=1
			_PRINT_FUNCS=0
			;;

		-t | --types)
			_PRINT_TYPES=1
			_PRINT_IFACES=0
			_PRINT_FUNCS=0
			;;

		-s | --short)
			_SHORT=1
			;;

		--)
			shift
			break
			;;
		esac

		shift
	done

	_go_ids "$@"
}

_go_ids() {
	local _pkgs="$@"

	if [ -z "$_pkgs" ]; then
		_pkgs="$(_stdlib_pkgs)"
	fi

	local _pkg=""

	for _pkg in $_pkgs; do
		local ids="$(_pkg_ids "$_pkg")"

		if [ "$_PRINT_TYPES" -eq 1 ]; then
			ids="$(echo "$ids" | grep "^type " | tee)"

			if [ "$_PRINT_IFACES" -eq 1 ]; then
				ids="$(echo "$ids" | grep " interface{ ... }$" | tee)"
			fi
		elif [ "$_PRINT_FUNCS" -eq 1 ]; then
			ids="$(echo "$ids" | grep "^func " | tee)"
		fi

		ids="$(echo "$ids" | sed "s/ /%20/g")"
		local _id=""

		for _id in $ids; do
			if echo "$_id" | grep -q "^type"; then
				_id="$(
					echo "$_id" |
						sed "s/%20/ /g" |
						cut -d " " -f 2 |
						cut -d "[" -f 1
				)"
			elif echo "$_id" | grep -q "^func"; then
				_id="$(
					echo "$_id" |
						sed "s/%20/ /g" |
						cut -d " " -f 2 |
						cut -d "(" -f 1
				)"
			fi

			if [ "$_SHORT" -eq 1 ]; then
				echo "${_pkg##*/}.$_id"
			else
				echo "$_pkg.$_id"
			fi
		done
	done
}

_pkg_ids() {
	local _pkg="$1"

	"$_GO" doc -short "$_pkg" |
		sed "s/^[[:space:]]+//g" |
		grep -v "^const" |
		grep -v "^var" |
		tee
}

_stdlib_pkgs() {
	cd "$("$_GO" env "GOROOT")"

	"$_GO" list "..." |
		grep -v "^_" |
		grep -v "^cmd/" |
		grep -v "^internal/" |
		grep -v "/internal$" |
		grep -v "/internal/" |
		grep -v "^golang.org/"
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - Print exported data types and functions from the given Go packages
(or the standard library if none).

Usage: $_name [-f | -i | -t] [OPTIONS] [PACKAGE]...

Options:
  -f, --funcs    Print functions
  -h, --help     Show this help message
  -i, --ifaces   Print interface types
  -s, --short    Don't print full package import path
  -t, --types    Print all data types (including interfaces)

Copyright (c) 2020 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

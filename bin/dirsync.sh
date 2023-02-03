#!/bin/sh
# Copyright (c) 2023 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

_RSYNC="${RSYNC:-"rsync"}"

_main() {
	if [ $# -eq 0 ]; then
		log.sh -f "no arguments given"
	fi

	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	local _cmd="$_RSYNC"

	while [ $# -gt 0 ]; do
		if [ "$1" = "--" ]; then
			shift
			break
		fi

		local _arg="$1"

		if echo "$_arg" | grep -q '\s'; then
			_arg="'$_arg'"
		fi

		_cmd="$_cmd $_arg"
		shift
	done

	if [ $# -lt 1 ]; then
		log.sh -f "no source given"
	fi

	local _src="${1%/}"
	shift

	if [ $# -lt 1 ]; then
		log.sh -f "no destination given"
	fi

	local _dst="${1%/}"
	shift

	if [ $# -eq 0 ]; then
		log.sh "synchronizing full directory"
		eval set -- "/"
	fi

	local _target=""

	for _target in "$@"; do
		local __src="${_src%/}/$_target"
		local __dst="${_dst%/}/$_target"

		cmd.sh mkdir -p "${__dst%/*}"
		cmd.sh sh -c "$_cmd '$__src' '$__dst'"
	done
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - rsync helper for directory synchronization with shell expansion.

Usage: $_name [RSYNC_OPTION] -- SRC DEST [ITEM]... 

Options:
  -h, --help   Show this help message

Environment variables:
  * 'RSYNC' is the rsync binary to be used. ($_RSYNC)

Examples:

  * Clone full Alpine Linux package repository:

    $_name -- rsync://rsync.alpinelinux.org/alpine ~/Downloads/alpine

  * Clone Alpine Linux edge branch:

    $_name -- rsync://rsync.alpinelinux.org/alpine ~/Downloads/alpine edge/

  * Clone Alpine Linux edge branch for aarch64 and x86_64 architectures:

    $_name -- rsync://rsync.alpinelinux.org/alpine ~/Downloads/alpine edge/{main,community,testing}/{aarch64,x86_64}/

  * Clone Alpine Linux stable branches 3.14, 3.15 and 3.16 without releases:

    $_name -- rsync://rsync.alpinelinux.org/alpine ~/Downloads/alpine v3.1{4,5,6}/{main,community}/

For logging options see 'log.sh --help'.

Copyright (c) 2023 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

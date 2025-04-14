#!/bin/sh
# Copyright (c) 2023 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eo pipefail

_CMD="${CMD:-"rsync"}"

_main() {
	if [ $# -eq 0 ]; then
		log.sh -f "no arguments given"
	fi

	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	local _args=""
	local _link=0

	while [ $# -gt 0 ]; do
		if [ "$1" = "--" ]; then
			shift
			break
		fi

		local _arg="$1"

		if echo "$_arg" | grep -q '^--link-dest=\?'; then
			_link=1

			if [ "$_arg" = "--link-dest" ]; then
				shift
			fi

			shift
			continue
		fi

		if echo "$_arg" | grep -q '\s'; then
			_arg="'$_arg'"
		fi

		_args="$_args $_arg"
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

		if [ $_link -gt 0 ]; then
			_args="$_args --link-dest"

			if [ -d "$__src" ]; then
				_args="$_args '$__src'"
			else
				_args="$_args '$_src'"
			fi
		fi

		local __cmd="$_CMD"
		local __args="$_args"

		if echo "$_CMD" | grep -q 'rclone$'; then
			if [ -f "$__src" ] || [ -f "$__dst" ]; then
				__cmd="$__cmd copyto"
				__args=""
			else
				__cmd="$__cmd sync"
			fi
		fi

		cmd.sh sh -c "$__cmd $__args '$__src' '$__dst'"
	done
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - directory synchronization with shell expansion.

Usage: $_name [CMD_OPTION]... -- SRC DEST [ITEM]... 

Options:
  -h, --help   Show this help message

  For logging options see 'log.sh --help'.

Environment variables:
  - 'CMD' is the syncronization command to be used. ($_CMD)

Examples:

  - Clone full Alpine Linux package repository:

    $_name -- rsync://rsync.alpinelinux.org/alpine ~/Downloads/alpine

  - Clone Alpine Linux edge branch:

    $_name -- rsync://rsync.alpinelinux.org/alpine ~/Downloads/alpine edge/

  - Clone Alpine Linux edge branch for aarch64 and x86_64 architectures:

    $_name -- rsync://rsync.alpinelinux.org/alpine ~/Downloads/alpine edge/{main,community,testing}/{aarch64,x86_64}/

  - Clone Alpine Linux stable branches 3.16, 3.17 and 3.18 without releases:

    $_name -- rsync://rsync.alpinelinux.org/alpine ~/Downloads/alpine v3.1{6,7,8}/{main,community}/

  - Clone full Alpine Linux package repository with rsync flags:

    $_name -azAHXh --delay-updates --delete-delay --progress -- rsync://rsync.alpinelinux.org/alpine ~/Downloads/alpine

Copyright (c) 2023 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

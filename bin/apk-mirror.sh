#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

_ALPINE_MIRROR="${ALPINE_MIRROR:-"rsync://rsync.alpinelinux.org/alpine"}"

_main() {
	if [ $# -eq 0 ]; then
		log.sh -f "no destination or options given"
		return 1
	fi

	local _flags="-aHX"

	local _opts="hz"
	local _lopts="compress,help,no-linux"

	eval set -- "$(
		getopt --options "$_opts" --longoptions "$_lopts" --name "$0" -- "$@"
	)"

	while [ $# -gt 0 ]; do
		case $1 in
		-h | --help)
			_show_help
			return
			;;

		--no-linux)
			local _flags="-rlt"
			;;

		-z | --compress)
			local _flags="${_flags}z"
			;;

		--)
			shift
			break
			;;
		esac

		shift
	done

	local _flags="${_flags}h"

	local _dest="${1%/}"
	shift

	if [ ! -d "$_dest" ]; then
		log.sh -f "destination is not a directory or doesn't exist"
		return 1
	fi

	local _target=""

	for _target in "$@"; do
		_target="${_target%/}"
		cmd.sh mkdir -p "$_dest/$_target"

		cmd.sh rsync "$_flags" --delete-after --progress \
			"$_ALPINE_MIRROR/$_target/" "$_dest/$_target/"
	done
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - clone Alpine Linux mirrors easily.

Usage: $_name [--no-linux] [OPTIONS] DEST TARGET...

Options:
  -z, --compress   Use compression during
  -h, --help       Show this help message
      --no-linux   Allow mirroring to non-Linux file systems.

Environment variables:
  * 'ALPINE_MIRROR' is the rsync mirror used to download the Alpine packages.
    ($_ALPINE_MIRROR)

Examples:

  * Clone edge branch:

    $_name ~/Downloads/alpine edge

  * Clone edge branch for aarch64 and x86_64 architectures:

    $_name ~/Downloads/alpine edge/{community,main,testing}/{aarch64,x86_64}

  * Clone stable branches 3.14, 3.15 and 3.16 without releases:

    $_name ~/Downloads/alpine v3.1{4,5,6}/{community,main}

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

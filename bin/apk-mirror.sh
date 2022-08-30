#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

_ALPINEMIRROR="${ALPINEMIRROR:-"rsync://rsync.alpinelinux.org/alpine"}"

_main() {
	if [ $# -eq 0 ]; then
		log.sh -f "no destination or options given"
		return 1
	fi

	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

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

		cmd.sh rsync -aHXzh --delete-after --progress \
			"$_ALPINEMIRROR/$_target/" "$_dest/$_target/"
	done
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - clone Alpine Linux mirrors easily.

Usage: $_name DEST TARGET...

Options:
  -h, --help   Show this help message

Environment variables:
  * 'ALPINEMIRROR' is the rsync mirror used to download the Alpine packages.
    ($_ALPINEMIRROR)

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

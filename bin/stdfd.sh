#!/bin/sh
# Copyright (c) 2023 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -euo pipefail

_main() {
	if [ $# -eq 0 ]; then
		return 1
	fi

	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	case $1 in
	0 | i | in | input | stdin)
		if [ -n "${STDIN:-""}" ]; then
			echo "$STDIN"
			return
		fi

		local _file=""

		for _file in "/dev/stdin" "/proc/self/fd/0"; do
			[ ! -r "$_file" ] && continue
			echo "$_file"
			return
		done

		_file="$(mktemp -u)"
		mkfifo "$_file"
		tail -f - >> "$_file" &
		;;

	1 | o | out | output | stdout)
		if [ -n "${STDOUT:-""}" ]; then
			echo "$STDOUT"
			return
		fi

		local _file=""

		for _file in "/dev/stdout" "/proc/self/fd/1"; do
			[ ! -w "$_file" ] && continue
			echo "$_file"
			return
		done

		_file="$(mktemp -u)"
		mkfifo "$_file"
		tail -f "$_file" &
		echo "$_file"
		;;

	2 | e | err | error | stderr)
		if [ -n "${STDERR:-""}" ]; then
			echo "$STDERR"
			return
		fi

		local _file=""

		for _file in "/dev/stderr" "/proc/self/fd/2"; do
			[ ! -w "$_file" ] && continue
			echo "$_file"
			return
		done

		_file="$(mktemp -u)"
		mkfifo "$_file"
		tail -f "$_file" 1>&2 &
		echo "$_file"
		;;
	esac
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - get path to standard file descriptors (stdin, stdout, stderr).

Usage: $_name [OPTIONS] FILE_DESCRIPTOR

Options:
  -h, --help              Show this help message

Environment variables:
  * 'STDERR' uses its contents as path to stderr.
  * 'STDIN' uses its contents as path to stdin.
  * 'STDOUT' uses its contents as path to stdout.

Copyright (c) 2023 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

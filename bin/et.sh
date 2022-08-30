#!/bin/sh
# Copyright (c) 2017 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eu

export LOGPREFIX="${LOGPREFIX:-""}${0##*/}: "

_COUNT=0
_SLEEP=0

_main() {
	local _opts="hn:s:"
	local _lopts="count:,help,sleep:"

	eval set -- "$(
		getopt --options "$_opts" --longoptions "$_lopts" --name "$0" -- "$@"
	)"

	while [ $# -gt 0 ]; do
		case $1 in
		-h | --help)
			_show_help
			return
			;;

		-n | --count)
			_COUNT="$2"
			shift
			;;

		-s | --sleep)
			_SLEEP="$2"
			shift
			;;

		--)
			shift
			break
			;;
		esac

		shift
	done

	until "$@"; do
		local _err="$?"
		_COUNT="$((_COUNT - 1))"

		if [ "$_COUNT" -eq 0 ]; then
			return "$_err"
		elif [ "$_COUNT" -eq 1 ]; then
			log.sh "1 try remaining.."
		elif [ "$_COUNT" -gt 1 ]; then
			log.sh "$_COUNT tries remaining.."
		fi

		log.sh "waiting for $_SLEEP.."
		sleep $_SLEEP
	done
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - (Ensure Task) run a command until it gets done.

Usage: $_name [OPTIONS] [--] COMMAND

Options:
  -h, --help         Show this help message
  -n, --count=MAX    Run the given command for MAX times before failing
  -s, --sleep=TIME   Delay each run of the given command for TIME time

For logging options see 'log.sh --help'.

Copyright (c) 2017 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

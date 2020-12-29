#!/bin/sh
# Copyright (c) 2017 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eu

COUNT=0
SLEEP=0
VERBOSE=0

_main() {
	OPTS="hn:s:v"
	LOPTS="count:,help,sleep:,verbose"

	eval set -- "$(
		getopt --options "$OPTS" --longoptions "$LOPTS" --name "$0" -- "$@"
	)"

	while [ $# -gt 0 ]; do
		case $1 in
		-h | --help)
			_show_help
			return
			;;

		-n | --count)
			COUNT="$2"
			shift
			;;

		-s | --sleep)
			SLEEP="$2"
			shift
			;;

		-v | --verbose)
			VERBOSE=1
			;;

		--)
			shift
			break
			;;
		esac

		shift
	done

	until _run "$@"; do
		ERR="$?"
		COUNT="$((COUNT - 1))"

		if [ "$COUNT" -eq 0 ]; then
			return "$ERR"
		fi

		[ "$COUNT" -gt 0 ] && _log "$COUNT tries remaining.."
		_log "Waiting for $SLEEP.."
		sleep $SLEEP
	done
}

_log() {
	[ "$VERBOSE" -eq 0 ] && return
	printf "$@\n"
}

_run() {
	[ "$VERBOSE" -ne 0 ] && echo "\$ $@"
	"$@"
}

_show_help() {
	BIN_NAME="$(basename "$0")"

	cat << EOF
$BIN_NAME - (Ensure Task) run a command until it gets done.

Usage: $BIN_NAME [OPTIONS] [--] COMMAND

Options:
  -h, --help         Show this help message
  -n, --count=MAX    Run the given command for MAX times before failing
  -s, --sleep=TIME   Delay each run of the given command for TIME time
  -v, --verbose      Show information about what is happening

Copyright (c) 2017 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

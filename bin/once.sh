#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eu

_TMPDIR="${TMPDIR:-"/tmp"}"
_USER="${USER:-"$(whoami)"}"

_BASEDIR="$_TMPDIR/once.sh"
_CLEAN_ON_EXIT=0
_FILE=""
_REF="$_USER"
_TRACK_ARGS=1
_USE_REF=0

_main() {
	local _args="$0 $@"
	local _opts="hr:su:"
	local _lopts="help,ignore-args,ref:,system,user:"

	local _getopt

	_getopt="$(
		getopt --options "$_opts" --longoptions "$_lopts" --name "$0" -- "$@"
	)"

	eval set -- "$_getopt"

	while [ $# -gt 0 ]; do
		case $1 in
		-h | --help)
			_show_help
			return
			;;

		--ignore-args)
			_TRACK_ARGS=0
			;;

		-r | --ref)
			_USE_REF=1
			_REF="$2"
			shift
			;;

		-s | --systen)
			_REF="_system"
			;;

		-u | --user)
			_REF="$2"
			shift
			;;

		--)
			shift
			break
			;;
		esac

		shift
	done

	mkdir -p -m 777 "$_BASEDIR"

	_FILE="$_BASEDIR/$(_get_name "$@")"

	if [ -f "$_FILE" ]; then
		echo "command already running" > /dev/stderr
		return 1
	fi

	echo "$_args" > "$_FILE"
	_CLEAN_ON_EXIT=1
	"$@"
}

_clean() {
	if [ $_CLEAN_ON_EXIT -eq 0 ]; then
		return
	fi

	rm -f "$_FILE"
}

_get_name() {
	if [ $_USE_REF -eq 1 ]; then
		echo "$_REF"
		return
	fi

	local _name="$@"

	if [ $_TRACK_ARGS -eq 0 ]; then
		_name="$1"
	fi

	local _hash="$(echo "$_name" | sha256sum | cut -d ' ' -f 1)"

	echo "$_REF-$_hash"
}

_on_exit() {
	local _err=$?

	_clean
	trap - INT
	trap - EXIT
	return $_err
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - run some task once per user, system or a custom reference.

Usage: $_name [OPTIONS] [MODE] -- COMMAND [ARGS]

Options:
  --ignore-args    Use only COMMAND for uniqueness tracking
  -h, --help       Show this help message

Modes:
  -r, --ref=REFERENCE   Use REFERENCE as uniqueness tracking reference
  -s, --system          Track uniqueness globally (any user in the system)
  -u, --user=USER       Track uniqueness for the given user

  If no mode is given, '-u $_USER' will be used.

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

	return
}

trap true INT
trap _on_exit EXIT

_main "$@"

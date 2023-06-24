#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eo pipefail

_main() {
	local _mode="encrypt"
	local _out="-"
	local _pass=""

	local _opts="dho:p:"
	local _lopts="decrypt,help,output:,passphrase:"

	eval set -- "$(
		getopt --options "$_opts" --longoptions "$_lopts" --name "$0" -- "$@"
	)"

	while [ $# -gt 0 ]; do
		case $1 in
		-d | --decrypt)
			_mode="decrypt"
			;;

		-h | --help)
			_show_help
			return
			;;

		-o | --output)
			_out="$2"
			shift
			;;

		-p | --passphrase)
			_pass="$2"
			shift
			;;

		--)
			shift
			break
			;;
		esac

		shift
	done

	local _args="-c --cipher-algo AES256"

	if [ "$_mode" = "decrypt" ]; then
		_args="-dq --no-symkey-cache"
	fi

	if [ -n "$_pass" ]; then
		_args="$_args --yes --passphrase '$_pass'"

		if [ "$_mode" = "decrypt" ]; then
			_args="$_args --batch"
		fi
	fi

	local _file="${1:-"-"}"

	cmd.sh gpg $_args -o "$_out" "$_file"
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - (en|de)crypt the given file.

Usage: $_name [OPTIONS] [FILE]

If no passphrase is given, it will be prompted.

If no file is given, it will be read from STDIN.

Options:
  -d, --decrypt           Decrypt input
  -h, --help              Show this help message
  -o, --output=FILE       Write output to FILE
  -p, --passphrase=PASS   Use the given passphrase

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

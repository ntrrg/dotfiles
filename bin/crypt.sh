#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eo pipefail

_main() {
	local _mode="encrypt"
	local _out="-"
	local _pass=""
	local _confirm=0

	local _opts="cdho:p:"
	local _lopts="confirm,decrypt,help,output:,passphrase:"

	eval set -- "$(
		getopt --options "$_opts" --longoptions "$_lopts" --name "$0" -- "$@"
	)"

	while [ $# -gt 0 ]; do
		case $1 in
		-c | --confirm)
			_confirm=1
			;;

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

	case "$_mode" in
	encrypt)
		local _args="-c --cipher-algo AES256"
		local _orig_out="$_out"

		if [ -n "$_pass" ]; then
			_args="$_args --batch --yes --passphrase '$_pass'"
		fi

		local _file="${1:-"-"}"

		if [ "$_out" != "-" ] && [ $_confirm -eq 1 ]; then
			_out="$_out.new"
		fi

		cmd.sh gpg $_args -o "$_out" "$_file"

		if [ "$_out" != "$_orig_out" ]; then
			_main -d "$_out" > "/dev/null" || log.sh -f "passphrases don't match"
			mv "$_out" "$_orig_out"
		fi
		;;

	decrypt)
		local _args="-dq --no-symkey-cache"

		if [ -n "$_pass" ]; then
			_args="$_args --batch --yes --passphrase '$_pass'"
		fi

		local _file="${1:-"-"}"

		gpg $_args -o "$_out" "$_file"
		;;

	*)
		log.sh -f "invalid mode '$_mode'"
		;;
	esac
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - (en|de)crypt the given file.

Usage: $_name [OPTIONS] [FILE]

If no passphrase is given, it will be prompted.

If no file is given, it will be read from STDIN.

Options:
  -c, --confirm           Confirm passphrase, ignored during decryption
  -d, --decrypt           Decrypt input
  -h, --help              Show this help message
  -o, --output=FILE       Write output to FILE
  -p, --passphrase=PASS   Use the given passphrase

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

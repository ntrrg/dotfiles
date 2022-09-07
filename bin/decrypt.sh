#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	local _pass=""

	if [ "$1" = "-p" ] || [ "$1" = "--passphrase" ]; then
		_pass="$2"
		shift
		shift
	fi

	if [ -n "$_pass" ]; then
		_pass="--yes --batch --passphrase '$_pass'"
	fi

	local _file="${1:-"-"}"

	gpg -dq --no-symkey-cache $_pass -o - "$_file"
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - decrypt the given file.

Usage: $_name [-p PASSPHRASE] [ENCRYPTED_FILE]

If no passphrase is given, it will be prompted.

If no file is given, it will be read from STDIN.

Options:
  -h, --help              Show this help message
  -p, --passphrase=PASS   Use the given passphrase

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"
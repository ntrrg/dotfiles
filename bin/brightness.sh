#!/bin/sh
# Copyright (c) 2020 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eo pipefail

_DRIVERS="$(find "/sys/class/backlight/" -mindepth 1 -maxdepth 1)"
_DRIVER="${DRIVER:-"$(echo "$_DRIVERS" | head -n 1)"}"

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	if [ $# -eq 0 ]; then
		local _current=0
		_current="$(cat "$_DRIVER/brightness")"

		local _max=0
		_max="$(cat "$_DRIVER/max_brightness")"

		echo "$((_current * 100 / _max))"

		return
	fi

	local _driver=""

	for _driver in $_DRIVERS; do
		local _max=0
		_max="$(cat "$_driver/max_brightness")"

		local _val=0

		case $1 in
		[+]100 | [+][1-9][0-9] | [+][0-9])
			_val=$(($($0) + $(echo "${1##*+}")))
			;;

		[-]100 | [-][1-9][0-9] | [-][0-9])
			_val=$(($($0) - $(echo "${1##*-}")))
			;;

		[*]100 | [*][1-9][0-9] | [*][0-9])
			_val=$(($($0) * $(echo "${1##*\*}")))
			;;

		[/]100 | [/][1-9][0-9] | [/][0-9])
			_val=$(($($0) / $(echo "${1##*/}")))
			;;

		100 | [1-9][0-9] | [0-9])
			_val=$1
			;;

		*)
			_show_help
			exit 1
			;;
		esac

		if [ "$_val" -lt 0 ]; then
			_val=0
		elif [ "$_val" -gt 100 ]; then
			_val=100
		fi

		_val="$((_val * _max / 100))"
		echo "$_val" 2> "/dev/null" > "$_driver/brightness" ||
			su - -c "echo '$_val' > '$_driver/brightness'"
	done
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - manage screen brightness.

Usage: $_name [[+-*/]VALUE]

Print current brightness value or set it to VALUE% if some value is given.
Root permissions are required for setting a new screen brightness.

Options:
  -h, --help   Show this help message

Environment variables:
  * 'DRIVER' points to the brightness control directory, useful for avoiding
    ambiguity between video controllers. ($_DRIVER)

Copyright (c) 2020 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

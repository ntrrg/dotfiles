#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

_BATTERIES="$(find "/sys/class/power_supply/" -mindepth 1 -maxdepth 1)"
_BATTERY="${BATTERY:-"$(echo "$_BATTERIES" | grep "BAT" | head -n 1)"}"

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	local _current=0
	_current="$(cat "$_BATTERY/charge_now")"

	local _max=0
	_max="$(cat "$_BATTERY/charge_full")"

	echo "${_BATTERY##*/}: $((_current * 100 / _max))%"
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - get batteries information.

Usage: $_name

Options:
  -h, --help   Show this help message

Environment variables:
  * 'BATTERY' points to the battery control directory, useful for avoiding
    ambiguity between batteries. ($_BATTERY)

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

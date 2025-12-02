#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eo pipefail

_BATTERIES="$(find "/sys/class/power_supply/" -iname "BAT*" -mindepth 1 -maxdepth 1)"

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	local _battery=""

	for _battery in $_BATTERIES; do
		local _current=0
		_current="$(cat "$_battery/charge_now")"

		local _max=0
		_max="$(cat "$_battery/charge_full_design")"

		local _full=0
		_full="$(cat "$_battery/charge_full")"

		if [ $_full -gt $_max ]; then
			_max="$_full"
		fi

		local _current_p="$((_current * 100 / _max))"

		local _status=0
		_status="$(cat "$_battery/status")"

		local _consumption=""

		if [ "$_status" = "Discharging" ] && command -v upower > "/dev/null"; then
			_info="$(upower -i /org/freedesktop/UPower/devices/battery_${_battery##*/})"
			_rate="$(echo "$_info" | grep "energy-rate:" | grep -oE '[0-9]+(\.[0-9]+)?')"
			_current="$(echo "$_info" | grep "energy:" | grep -oE '[0-9]+(\.[0-9]+)?')"
			_consumption=" @ $_rate W of $_current Wh"
		fi

		echo "${_battery##*/}: $_current_p% ($_status$_consumption)"
	done
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - get batteries information.

Usage: $_name

Options:
  -h, --help   Show this help message

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

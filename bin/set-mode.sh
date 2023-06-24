#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -euo pipefail

export LOGPREFIX="${LOGPREFIX:-""}${0##*/}: "

_main() {
	if [ $# -eq 0 ]; then
		log.sh -f "no mode or options given"
	fi

	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	if [ "$1" = "-l" ] || [ "$1" = "--list" ]; then
		_list_outputs
		return
	fi

	local _output="$1"
	local _x="$2"
	local _y="$3"
	local _refresh="${4:-60}"

	local _mode="$(
		cvt "$_x" "$_y" "$_refresh" |
			grep "Modeline" |
			sed "s/Modeline //" |
			sed 's/"//g'
	)"

	local _mode_name="$(printf "$_mode" | cut -d " " -f 1)"

	xrandr --newmode $_mode
	xrandr --addmode "$_output" "$_mode_name"
	xrandr --output "$_output" --mode "$_mode_name"
}

_list_outputs() {
	xrandr | grep "\(dis\)\?connected" | cut -d " " -f 1,2
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - set screen resolution.

Usage: $_name [OPTIONS] OUTPUT X Y [REFRESH]

Options:
  -l, --list   List available screens
  -h, --help   Show this help message

For logging options see 'log.sh --help'.

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

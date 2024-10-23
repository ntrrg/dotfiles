#!/bin/sh
# Copyright (c) 2024 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -euo pipefail

export LOGPREFIX="${LOGPREFIX:-""}${0##*/}: "

_main() {
	if [ $# -eq 0 ]; then
		log.sh -f "no command or options given"
	fi

	case $1 in
	-h | --help)
		_show_help
		;;

	l | ls | list)
		shift
		_cmd_list "$@"
		;;

	m | mode)
		shift
		_cmd_mode "$@"
		;;

	t | turn)
		shift
		_cmd_turn "$@"
		;;

	*)
		log.sh -f "invalid command: '$1'"
		;;
	esac
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - screen management tools.

Usage: $_name [OPTIONS] COMMAND

Commands:
  list   List available screens
  mode   Set display resolution
  turn   Turn on/off screens

Options:
  -h, --help   Show this help message

For logging options see 'log.sh --help'.

Copyright (c) 2024 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

# ######
# List #
# ######

_cmd_list() {
	if [ $# -gt 0 ]; then
		if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
			_show_help_list
			return
		fi
	fi

	case "$(_window_server)" in
	wayland)
		_cmd_list_wayland
		;;

	xorg)
		_cmd_list_xorg
		;;
	esac
}

_cmd_list_wayland() {
	wlr-randr | grep -v '^ ' | cut -d ' ' -f 1
}

_cmd_list_xorg() {
	xrandr | grep '\(dis\)\?connected' | cut -d ' ' -f 1
}

_show_help_list() {
	local _name="${0##*/}"

	cat << EOF
$_name list - list available screens.

Usage: $_name [OPTIONS]

Options:
  -h, --help   Show this help message
EOF
}

# ######
# Mode #
# ######

_cmd_mode() {
	if [ $# -eq 0 ]; then
		log.sh -f "no arguments or options given"
	fi

	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help_mode
		return
	fi

	if [ $# -lt 3 ]; then
		log.sh -f "invalid arguments"
	fi

	local _screen="$1"
	local _x="$2"
	local _y="$3"
	local _rate="${4:-60}"

	case "$(_window_server)" in
	wayland)
		_cmd_mode_wayland "$_screen" "$_x" "$_y" "$_rate"
		;;

	xorg)
		_cmd_mode_xorg "$_screen" "$_x" "$_y" "$_rate"
		;;
	esac
}

_cmd_mode_wayland() {
	local _screen="$1"
	local _x="$2"
	local _y="$3"
	local _rate="${4:-60}"

	wlr-randr --output "$_screen" --custom-mode "${_x}x${_y}@${_rate}Hz"
}

_cmd_mode_xorg() {
	local _screen="$1"
	local _x="$2"
	local _y="$3"
	local _rate="${4:-60}"

	local _mode="$(
		cvt "$_x" "$_y" "$_rate" |
			grep "Modeline" |
			sed "s/Modeline //" |
			sed 's/"//g'
	)"

	local _mode_name="$(printf "$_mode" | cut -d " " -f 1)"

	xrandr --newmode $_mode
	xrandr --addmode "$_screen" "$_mode_name"
	xrandr --output "$_screen" --mode "$_mode_name"
}

_show_help_mode() {
	local _name="${0##*/}"

	cat << EOF
$_name mode - set display resolution.

Usage: $_name [OPTIONS] SCREEN X Y [REFRESH_RATE]

Options:
  -h, --help   Show this help message
EOF
}

# ######
# Turn #
# ######

_cmd_turn() {
	if [ $# -eq 0 ]; then
		log.sh -f "no arguments or options given"
	fi

	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help_turn
		return
	fi

	local _mode="$1"
	shift

	if [ "$_mode" != "on" ] && [ "$_mode" != "off" ] && [ "$_mode" != "toggle" ]; then
		log.sh -f "invalid mode: '$1'"
	fi

	local _screens="$@"

	if [ $# -eq 0 ] || [ "$1" = "all" ]; then
		_screens="$(_cmd_list)"
	fi

	local _screen=""

	case "$(_window_server)" in
	wayland)
		for _screen in $_screens; do
			_cmd_turn_wayland "$_mode" "$_screen"
		done
		;;

	xorg)
		for _screen in $_screens; do
			_cmd_turn_xorg "$_mode" "$_screen"
		done
		;;
	esac
}

_cmd_turn_wayland() {
	wlr-randr --output "$2" "--$1"
}

_cmd_turn_xorg() {
	xrandr --output "$2" "--$1"
}

_show_help_turn() {
	local _name="${0##*/}"

	cat << EOF
$_name turn - turn on/off screens.

Usage: $_name [OPTIONS] on/off/toggle [SCREEN...]

Options:
  -h, --help   Show this help message
EOF
}

# #######
# Tools #
# #######

_is_wayland() {
	if [ "$(_window_server)" != "wayland" ]; then
		return 1
	fi
}

_is_xorg() {
	if [ "$(_window_server)" != "xorg" ]; then
		return 1
	fi
}

_window_server() {
	if [ -n "$WAYLAND_DISPLAY" ]; then
		echo "wayland"
	else
		echo "xorg"
	fi
}

_main "$@"

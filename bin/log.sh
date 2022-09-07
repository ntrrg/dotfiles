#!/bin/sh
# Copyright (c) 2022 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eu

_COLORIZE="${LOGCOLORIZE:-1}"
_DATE="${LOGDATE:-""}"
_FILE="${LOGFILE:-"/dev/stderr"}"
_LEVEL="${LOGLEVEL:-"WARN"}"
_LEVELIZE="${LOGLEVELIZE:-1}"
_PREFIX="${LOGPREFIX:-""}"

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	local _level="INFO"

	case $1 in
	-f | --fatal)
		_level="FATAL"
		shift
		;;

	-e | --error)
		_level="ERROR"
		shift
		;;

	-w | --warn)
		_level="WARN"
		shift
		;;

	-i | --info)
		_level="INFO"
		shift
		;;

	-d | --debug)
		_level="DEBUG"
		shift
		;;
	esac

	if ! _is_valid_level "$_level"; then
		return
	fi

	local _level_text=""

	if [ "$_LEVELIZE" -ne 0 ]; then
		_level_text="$_level"

		if [ "$_COLORIZE" -ne 0 ]; then
			_level_text="$(_level_to_color $_level)$_level_text\e[0m"
		fi

		_level_text="[$_level_text] "
	fi

	local _date=""

	if [ -n "$_DATE" ]; then
		_date="$(date "+$_DATE") "
	fi

	printf "$_level_text$_date$_PREFIX%s\n" "$(printf "$@")" >> "$_FILE"
}

_index_to_level() {
	local _level="${1:-""}"

	case "$_level" in
	0)
		echo "NONE"
		;;

	1)
		echo "FATAL"
		;;

	2)
		echo "ERROR"
		;;

	3)
		echo "WARN"
		;;

	4)
		echo "INFO"
		;;

	5)
		echo "DEBUG"
		;;

	*)
		echo "UNKNOWN"
		;;
	esac
}

_is_valid_level() {
	local _level="$(_level_to_index "$1")"
	local _active_level=$(_level_to_index "$_LEVEL")

	if [ $_level -le $_active_level ]; then
		return 0
	fi

	return 1
}

_level_to_color() {
	local _level="${1:-""}"

	case "$(echo "$_level" | tr '[:upper:]' '[:lower:]')" in
	none | 0)
		echo "\e[0m"
		;;

	fatal | 1)
		echo "\e[41;97m"
		;;

	err | error | 2)
		echo "\e[31m"
		;;

	warn | warning | 3)
		echo "\e[33m"
		;;

	info | 4)
		echo "\e[36m"
		;;

	debug | 5)
		echo "\e[34m"
		;;

	*)
		echo "\e[0m"
		;;
	esac
}

_level_to_index() {
	local _level="${1:-""}"

	case "$(echo "$_level" | tr '[:upper:]' '[:lower:]')" in
	none | 0)
		echo 0
		;;

	fatal | 1)
		echo 1
		;;

	err | error | 2)
		echo 2
		;;

	warn | warning | 3)
		echo 3
		;;

	info | 4)
		echo 4
		;;

	debug | 5)
		echo 5
		;;

	*)
		echo -1
		;;
	esac
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - simple logger with levels.

Usage: $_name [OPTIONS] [LEVEL] {MESSAGE | FORMAT ARG... }

Options:
  -h, --help   Show this help message

Levels:
  -d, --debug   Log message with DEBUG level.
  -e, --error   Log message with ERROR level.
  -f, --fatal   Log message with FATAL level.
  -i, --info    Log message with INFO level.
  -w, --warn    Log message with WARN level.

  If no level is given, -i will be used.

Environment variables:
  * 'LOGCOLORIZE' colorize logging level identifier. ($_COLORIZE)
  * 'LOGDATE' preprends date to every message using the given format. ($_DATE)
  * 'LOGFILE' determines where messages will be printed. ($_FILE)
  * 'LOGLEVEL' determines which level of messages will be printed. ($_LEVEL)
  * 'LOGLEVELIZE' prepreds logging level to every message. ($_LEVELIZE)
  * 'LOGPREFIX' preprends its content to every message. ($_PREFIX)

Copyright (c) 2022 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

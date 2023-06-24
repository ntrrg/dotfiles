#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eo pipefail

_main() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	local _prefix="B"

	if [ "$1" = "-p" ] || [ "$1" = "--prefix" ]; then
		_prefix="$2"
		shift
		shift
	fi

	local _ammount="$1"

	if [ -z "$_ammount" ]; then
		_ammount="$(cat -)"
	fi

	if [ -z "$_ammount" ]; then
		_ammount=0
	fi

	local _i="$(_prefix_to_index "$_prefix")"

	while true; do
		if [ "$_i" -eq 8 ] || [ "$(echo "$_ammount < 1024" | bc)" -eq 1 ]; then
			echo "$_ammount$(_index_to_prefix "$_i")"
			return
		fi

		_ammount=$(echo "scale=2; $_ammount / 1024" | bc)
		_i="$((_i + 1))"
	done
}

_index_to_prefix() {
	case "$1" in
	0)
		echo "B"
		;;

	1)
		echo "KiB"
		;;

	2)
		echo "MiB"
		;;

	3)
		echo "GiB"
		;;

	4)
		echo "TiB"
		;;

	5)
		echo "PiB"
		;;

	6)
		echo "EiB"
		;;

	7)
		echo "ZiB"
		;;

	8)
		echo "YiB"
		;;
	esac
}

_prefix_to_index() {
	case "$1" in
	B)
		echo 0
		;;

	K | Ki)
		echo 1
		;;

	M | Mi)
		echo 2
		;;

	G | Gi)
		echo 3
		;;

	T | Ti)
		echo 4
		;;

	P | Pi)
		echo 5
		;;

	E | Ei)
		echo 6
		;;

	Z | Zi)
		echo 7
		;;

	Y | Yi)
		echo 8
		;;

	*)
		echo -1
		;;
	esac
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - make a memory measure human-readable.

Usage: $_name [OPTIONS] AMOUNT

Options:
  -h, --help            Show this help message
  -p, --prefix=PREFIX   Treat AMOUNT as a value with a prefix multiplier of
                        PREFIX

Prefixes:
  * K, Ki
  * M, Mi
  * G, Gi
  * T, Ti
  * P, Pi
  * E, Ei
  * Z, Zi
  * Y, Yi

  Notice that AMOUNT will be always proccessed as a value of power of 2,
  regardless of using power of 10 prefixes (K, M, G, T, P, E, Z, Y).

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

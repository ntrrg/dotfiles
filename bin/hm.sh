#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	BIN_NAME="$(basename "$0")"

	cat << EOF
$BIN_NAME - make a memory measure human-readable.

Usage: $BIN_NAME [OPTIONS] AMOUNT

Options:
  -h, --help            Show this help message
  -p, --prefix=PREFIX   Treat AMOUNT as a value with a prefix multiplier of
                        PREFIX (K, Ki, M, Mi, G, Gi, T, Ti, P, Pi)

Prefixes:
  Notice that AMOUNT will be always proccessed as a value of power of 2,
  regardless if the given prefix is a power of 10 (K, M, G, T, P).

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

	exit
fi

_get_index_by_prefix() {
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
	esac
}

_get_prefix_by_index() {
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
	esac
}

PREFIX="B"

if [ "$1" = "-p" ] || [ "$1" = "--prefix" ]; then
	PREFIX="$2"
	shift
	shift
fi

AMOUNT="$1"

if [ -z "$AMOUNT" ]; then
	AMOUNT="$(cat -)"
fi

if [ -z "$AMOUNT" ]; then
	AMOUNT=0
fi

I="$(_get_index_by_prefix "$PREFIX")"

while true; do
	if [ "$I" -eq 5 ] || [ "$(echo "$AMOUNT < 1024" | bc)" -eq 1 ]; then
		echo "$AMOUNT$(_get_prefix_by_index "$I")"
		exit
	fi

	AMOUNT=$(echo "scale=2; $AMOUNT / 1024" | bc)
	I="$((I + 1))"
done

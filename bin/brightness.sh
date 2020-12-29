#!/bin/sh
# Copyright (c) 2020 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

BRIGHTNESS_DRIVERS="$(
	find "/sys/class/backlight/" -mindepth 1 -maxdepth 1 |
		head -n 1
)"

BRIGHTNESS_DRIVER="${BRIGHTNESS_DRIVER:-"$(
	echo "$BRIGHTNESS_DRIVERS" | head -n 1
)"}"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	BIN_NAME="$(basename "$0")"

	cat << EOF
$BIN_NAME - manage screen brightness.

Usage: $BIN_NAME [VALUE]

Set current screen brightness to VALUE%, or print current value if nothing is
given. Root permissions are required for setting a new screen brightness.

Options:
  -h, --help   Show this help message

Environment variables:
  * 'BRIGHTNESS_DRIVER' points to the brightness control directory, useful for
    avoiding ambiguity between video controllers. ($BRIGHTNESS_DRIVER)

Copyright (c) 2020 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

	exit
fi

if [ -z "$1" ]; then
	BRIGHTNESS="$(cat "$BRIGHTNESS_DRIVER/brightness")"
	MAX_BRIGHTNESS="$(cat "$BRIGHTNESS_DRIVER/max_brightness")"
	echo "$((BRIGHTNESS * 100 / MAX_BRIGHTNESS))"
	exit
fi

for BRIGHTNESS_DRIVER in $BRIGHTNESS_DRIVERS; do
	MAX_BRIGHTNESS="$(cat "$BRIGHTNESS_DRIVER/max_brightness")"
	VAL="$([ "$1" -gt 100 ] && echo 100 || echo "$1")"
	su -c "echo '$((VAL * MAX_BRIGHTNESS / 100))' > '$BRIGHTNESS_DRIVER/brightness'" -
done

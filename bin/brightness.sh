#!/bin/sh
# Copyright (c) 2020 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

main() {
  case $1 in
    -h | --help )
      show_help
      ;;

    -s | --set )
      val="$([ "$2" -gt 100 ] && echo 100 || echo "$2")"
      echo $(((val * MAX_BRIGHTNESS / 100))) > "$BRIGHTNESS_FILE"
      ;;

    * )
      echo $(((BRIGHTNESS * 100 / MAX_BRIGHTNESS + 1)))
      ;;
  esac
}

show_help() {
  BIN_NAME="$(basename "$0")"

  cat <<EOF
$BIN_NAME - manage screen brightnes.

Usage: $BIN_NAME [-s VALUE]

If no options are given, current percent screen brightnes is printed. Root
permissions are required for setting a new screen brightnes.

Options:
  -s, --set=VALUE   Set screen brightnes to given percent
  -h, --help        Show this help message

Copyright (c) 2020 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

BRIGHTNESS_DIR="$(find /sys/class/backlight/ -mindepth 1 -maxdepth 1)"
BRIGHTNESS_FILE="$BRIGHTNESS_DIR/brightness"
BRIGHTNESS="$(cat "$BRIGHTNESS_FILE")"
MAX_BRIGHTNESS="$(cat "$BRIGHTNESS_DIR/max_brightness")"

main "$@"


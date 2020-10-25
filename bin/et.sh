#!/bin/sh
# Copyright (c) 2017 Miguel Angel Rivera Notararigo
# Released under the MIT License

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  BIN_NAME="$(basename "$0")"

  cat <<EOF
$BIN_NAME - (Ensure Task) run a command until it gets done.

Usage: $BIN_NAME [OPTIONS] COMMAND

Options:
  -h, --help         Show this help message
  -s, --sleep=TIME   Delay each run of the given command for TIME time

Copyright (c) 2017 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

  exit
fi

if [ "$1" = "-s" ] || [ "$1" = "--sleep" ]; then
  SLEEP="sleep $2"
  shift; shift
fi

while true; do
  "$@" && break
  $SLEEP
done


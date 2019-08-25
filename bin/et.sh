#!/bin/sh
# Copyright (c) 2017 Miguel Angel Rivera Notararigo
# Released under the MIT License

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  cat <<EOF
$0 - run a command until it gets done.

Usage: $0 [OPTIONS] COMMAND

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


#!/bin/sh
# Copyright (c) 2017 Miguel Angel Rivera Notararigo
# Released under the MIT License

if [ "$1" = "-h" -o "$1" = "--help" ]; then
  cat <<EOF
$0 runs a command until gets done.

Usage: $0 [OPTIONS] COMMAND

Options:
  -h, --help   Show this help message.

Copyright (c) 2017 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

  exit 1
fi

while true; do
  $* && break
done


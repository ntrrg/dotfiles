#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

IS_CONTAINER=${IS_CONTAINER:-0}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  cat <<EOF
$0 - detect if running in a container.

Usage: $0 [OPTIONS]

Options:
  -h, --help   Show this help message.

Environment variables:
  * 'IS_CONTAINER' forces this program to exit with status 0 if its value is
    not 0. ($IS_CONTAINER)

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
fi

if [ "$IS_CONTAINER" -ne 0 ] ||
    grep -q "docker/" < /proc/self/cgroup||
    grep -q "kubepods/" < /proc/self/cgroup ||
    ischroot; then
  exit 0
fi

exit 1


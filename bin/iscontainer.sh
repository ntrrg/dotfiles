#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

IS_CONTAINER=${IS_CONTAINER:-0}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  BIN_NAME="$(basename "$0")"

  cat <<EOF
$BIN_NAME - check if the running system is a container.

Usage: $BIN_NAME [OPTIONS]

Options:
  -h, --help   Show this help message.
  -y, --yes    Force status 0 exit.

Environment variables:
  * 'IS_CONTAINER' forces this program to exit with status 0 if its value is
    not 0. ($IS_CONTAINER)

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
fi

if [ "$1" = "-y" ] || [ "$1" = "--yes" ]; then
  IS_CONTAINER=1;
fi

if [ "$IS_CONTAINER" -ne 0 ] ||
    grep -q "docker/" < /proc/self/cgroup||
    grep -q "kubepods/" < /proc/self/cgroup ||
    ischroot; then
  exit 0
fi

exit 1


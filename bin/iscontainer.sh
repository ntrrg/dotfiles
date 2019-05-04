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
  * 'IS_CONTAINER' if non-zero value, forces this program to exit with status
    0.

Exit status codes:
  0   running in a container
  1   not running in a container
  2   showing help message

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

  exit 2
fi

if [ $IS_CONTAINER -ne 0 ] ||
    cat /proc/self/cgroup | grep -q "docker/" ||
    cat /proc/self/cgroup | grep -q "kubepods/" ||
    ischroot; then
  exit 0
fi

exit 1


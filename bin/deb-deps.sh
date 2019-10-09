#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  cat <<EOF
$0 - get the dependencies from the given packages.

Usage: $0 PACKAGE...

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

  exit
fi

apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances -qq "$@" | tr -d " " | sed "s/Depends://" | sort -u


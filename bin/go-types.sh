#!/bin/sh
# Copyright (c) 2020 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

which go > /dev/null

PACKAGES="$(
  go list "$(go env GOROOT)/..." 2> /dev/null |
  grep -v "^_" |
  grep -v "^cmd/" |
  grep -v "^internal/" |
  grep -v "/internal$" |
  grep -v "/internal/"
)"

for PACKAGE in $PACKAGES; do
  TYPES="$( (
    go doc "$PACKAGE" |
      grep "^type [A-Z]" |
      sed "s/ /__SPACE__/g"
  ) || true)"

  for TYPE in $TYPES; do
    TYPE="$(echo "$TYPE" | sed "s/__SPACE__/ /g" | cut -d " " -f 2)"
    echo "$(basename $PACKAGE).$TYPE"
  done
done


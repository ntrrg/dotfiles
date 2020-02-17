#!/bin/sh
# Copyright (c) 2020 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

command -v go > /dev/null

PACKAGES="$(
  go list "$(go env GOROOT)/..." 2> /dev/null |
  grep -v "^_" |
  grep -v "^cmd/" |
  grep -v "^internal/" |
  grep -v "/internal$" |
  grep -v "/internal/"
)"

for PACKAGE in $PACKAGES; do
  FUNCS="$( (
    go doc "$PACKAGE" |
      grep "^func [A-Z]" |
      sed "s/ /__SPACE__/g"
  ) || true)"

  for FUNC in $FUNCS; do
    FUNC="$(
      echo "$FUNC" |
      sed "s/__SPACE__/ /g" |
      cut -d " " -f 2 |
      cut -d "(" -f 1
    )"

    echo "$(basename "$PACKAGE").$FUNC"
  done
done


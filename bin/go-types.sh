#!/bin/sh
# Copyright (c) 2020 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

command -v go > /dev/null

PACKAGES="$(
  cd $(go env "GOROOT") &&
  go list "..." 2> /dev/null |
  grep -v "^_" |
  grep -v "^cmd/" |
  grep -v "^internal/" |
  grep -v "/internal$" |
  grep -v "/internal/"
)"

for PACKAGE in $PACKAGES; do
  TYPES="$(
    go doc -short "$PACKAGE" |
    grep "^type [A-Z]" |
    sed "s/ /__SPACE__/g"
  )"

  for TYPE in $TYPES; do
    TYPE="$(
      echo "$TYPE" |
      sed "s/__SPACE__/ /g" |
      cut -d " " -f 2
    )"

    echo "$(basename "$PACKAGE").$TYPE"
  done
done


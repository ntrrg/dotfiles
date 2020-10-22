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
  FUNCS="$(
    go doc -short "$PACKAGE" |
    grep "^\s*func [A-Z]" |
    sed "s/^[[:space:]]*//g" |
    sed "s/ /__SPACE__/g"
  )"

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


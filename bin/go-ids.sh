#!/bin/sh
# Copyright (c) 2020 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

main() {
  OPTS="fhist"
  LOPTS="funcs,help,ifaces,short,types"

  eval set -- "$(
    getopt --options "$OPTS" --longoptions "$LOPTS" --name "$0" -- "$@"
  )"

  while [ $# -gt 0 ]; do
    case $1 in
      -h | --help )
        show_help
        return
        ;;

      -f | --funcs )
        PRINT_TYPES=0
        PRINT_IFACES=0
        PRINT_FUNCS=1
        ;;

      -i | --ifaces )
        PRINT_TYPES=1
        PRINT_IFACES=1
        PRINT_FUNCS=0
        ;;

      -t | --types )
        PRINT_TYPES=1
        PRINT_IFACES=0
        PRINT_FUNCS=0
        ;;

      -s | --short )
        SHORT=1
        ;;

      -- )
        shift
        break
        ;;
    esac

    shift
  done

  if [ $# -eq 0 ]; then
    PACKAGES="$(
      cd "$(go env "GOROOT")" &&
      go list "..." |
      grep -v "^_" |
      grep -v "^cmd/" |
      grep -v "^internal/" |
      grep -v "/internal$" |
      grep -v "/internal/" |
      grep -v "^golang.org/"
    )"
  fi

  for PACKAGE in ${PACKAGES:-$@}; do
    IDENTIFIERS="$(
      go doc -short "$PACKAGE" |
      sed "s/^[[:space:]]*//g" |
      grep -v "^const" |
      grep -v "^var"
    )"

    if [ "$PRINT_TYPES" -eq 1 ]; then
      IDENTIFIERS="$(echo "$IDENTIFIERS" | grep "^type ")"

      if [ "$PRINT_IFACES" -eq 1 ]; then
        IDENTIFIERS="$(echo "$IDENTIFIERS" | grep " interface{ ... }$")"
      fi
    elif [ "$PRINT_FUNCS" -eq 1 ]; then
      IDENTIFIERS="$(echo "$IDENTIFIERS" | grep "^func ")"
    fi

    IDENTIFIERS="$(echo "$IDENTIFIERS" | sed "s/ /%20/g")"

    for IDENTIFIER in $IDENTIFIERS; do
      if echo "$IDENTIFIER" | grep -q "^type"; then
        IDENTIFIER="$(
          echo "$IDENTIFIER" |
          sed "s/%20/ /g" |
          cut -d " " -f 2
        )"
      elif echo "$IDENTIFIER" | grep -q "^func"; then
        IDENTIFIER="$(
          echo "$IDENTIFIER" |
          sed "s/%20/ /g" |
          cut -d " " -f 2 |
          cut -d "(" -f 1
        )"
      fi

      if [ "$SHORT" -eq 1 ]; then
        echo "$(basename "$PACKAGE").$IDENTIFIER"
      else
        echo "$PACKAGE.$IDENTIFIER"
      fi
    done
  done
}

show_help() {
  BIN_NAME="$(basename "$0")"

  cat <<EOF
$BIN_NAME - Print exported data types and functions from the given Go package
(or the standard library if none).

Usage: $BIN_NAME [-f | -i | -t] [PACKAGE]...

Options:
  -f, --funcs    Print functions
  -h, --help     Show this help message
  -i, --ifaces   Print interface types
  -s, --short    Don't print full package import path
  -t, --types    Print all data types (including interfaces)

Copyright (c) 2020 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

command -v go > /dev/null

PRINT_TYPES=0
PRINT_IFACES=0
PRINT_FUNCS=0
SHORT=0
 
main "$@"


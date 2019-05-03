#!/bin/sh
# Copyright (c) 2018 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

main() {
  local OPTS="hrp:t:"
  local LOPTS="help,recursive,prefix:,push,tag:"

  eval set -- "$(
    getopt --options "$OPTS" --longoptions "$LOPTS" --name "$0" -- $@
  )"

  while [ $# -gt 0 ]; do
    case $1 in
      -h | --help )
        show_help
        exit 1
        ;;

      -r | --recursive )
        ;;

      -p | --prefix )
        ;;

      -t | --tag )
        ;;

      -- )
        shift
        break
        ;;
    esac

    shift
  done

  if [ -f "$1" ]; then
    build "$1"
  elif [ -d "$1" ]; then
    build "$1/Dockerfile"
  else
    FILES="$(find . -name "*Dockerfile")"

    for FILE in $FILES; do
      FILE="$(echo "$FILE" | sed -e "s/\\.\\///")"
      build "$FILE"
    done
  fi
}

build() {
  FILE="$1"
  CTX="$(dirname "$FILE")"
  IMAGE="$(basename "$CTX")"

  docker build -t "$PREFIX$IMAGE$SUFFIX" -f "$FILE" "$CTX"
}

show_help() {
  cat <<EOF
$0 is a Dockerfile build helper. It can build multiple Dockerfiles
with a single command.

Usage: $0 [OPTIONS] [BUILD_INSTRUCTION]...

A build instruction is a sentence that contains the needed information to run
this program in an arbitrary behavior. It's syntax is:

  [PATH][@REPO][:TAG][#GIT_REF]

  * PATH could be a Dockerfile or a directory containing a Dockerfile. It can't
    content at symbols (@), colons (:) or hashes (#). E.g. '~/my-image'.
  * @REPO is the repository name. E.g. '@ntrrg/my-image'. 
  * :TAG is the tag used for the Docker repository. E.g. ':0.1.0'
  * #GIT_REF is the Git reference used as working tree. E.g. '#v0.1.0'

If just PATH or none is given, by default, the Dockerfile directory name will
be used as repository name and 'latest' as tag. Here is a list of ways to
override this behavior (in order of precedence):
  * PREFIX and TAG environment variables. They will be prepended/appended
    respectively to any given PATH.
  * '-p, --prefix' and '-t/--tags' flags have the same behavior as above.
  * Configuration file, see Configuration file syntax section.
  * Specific build instructions.

Options:
  -c, --config=NAME     Set the configuration file name (.docker-build)
  -f, --file=NAME       Set the Dockerfile name (Dockerfile)
  -g, --git-ref=REF     Use REF as Git working tree
  -h, --help            Show this help message
  -p, --prefix=PREFIX   Prepend PREFIX to the Docker repository name
      --push            Push the images after building them
  -r, --recursive       Look for Dockerfiles in the given folders recursively
  -t, --tag=TAG         Append TAG to the Docker repository name

Configuration file syntax:
  A configuration file is a line-separated list of build instructions. That
  means that a single Dockerfile could be built multiple times with just one
  call of this program.

Copyright (c) 2018 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

main $@


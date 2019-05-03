#!/bin/sh
# Copyright (c) 2018 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

CONFIGFILE=".docker-build"
DOCKERFILE="Dockerfile"
GIT_REF=""
PUSH=0
PREFIX="${PREFIX:-}"
RECURSIVE=0
TAG="${TAG:-latest}"

main() {
  local OPTS="c:g:hp:rt:"
  local LOPTS="config:,git-ref:,help,prefix:,push,recursive,tag:"

  eval set -- "$(
    getopt --options "$OPTS" --longoptions "$LOPTS" --name "$0" -- $@
  )"

  while [ $# -gt 0 ]; do
    case $1 in
      -h | --help )
        show_help
        exit 1
        ;;

      -c | --config )
        CONFIGFILE="$2"
        shift
        ;;

      -f | --file )
        DOCKERFILE="$2"
        shift
        ;;

      -g | --git-ref )
        GIT_REF="$2"
        shift
        ;;

      -p | --prefix )
        PREFIX="$2"
        shift
        ;;

      --push )
        PUSH=1
        ;;

      -r | --recursive )
        RECURSIVE=1
        ;;

      -t | --tag )
        TAG="$2"
        shift
        ;;

      -- )
        shift
        break
        ;;
    esac

    shift
  done

  if [ $# -eq 0 ]; then
    eval set -- "$PWD"
  fi

  for BI in $@; do
    build "$BI"
  done
}

build() {
  local BI="$1"

  if [ -d "$BI" ]; then
    if [ $RECURSIVE -eq 0 ]; then
      if [ -f "$BI/$CONFIGFILE" ]; then
        echo "Config"
      elif [ -f "$BI/$DOCKERFILE" ]; then
        build "$BI/$DOCKERFILE"
      else
        echo "$BI doesn't have any $DOCKERFILE or $CONFIGFILE files"
        exit 1
      fi
    else
      FILES="$(find $BI -name "$DOCKERFILE")"

      for FILE in $FILES; do
        build "$FILE"
      done
    fi
  else
    local FILE="$BI"
    local CTX="$(dirname "$FILE")"
    local IMAGE="$(basename "$CTX")"

    echo docker build -t "$PREFIX$IMAGE$SUFFIX" -f "$FILE" "$CTX"

    if [ $PUSH -ne 0 ]; then
      echo docker push "$REPOSITORY"
    fi
  fi
}

show_help() {
  cat <<EOF
$0 is a Dockerfile build helper. It can build multiple Dockerfiles
with a single command.

Usage: $0 [OPTIONS] [PATH | BUILD_INSTRUCTION]...

A build instruction is a sentence that contains the needed information to run
this program in an arbitrary behavior. It's syntax is:

  PATH[@REPO][:TAG][#GIT_REF]

  * PATH is a Dockerfile path. It can't content at symbols (@), colons (:) or
    hashes (#). E.g. '~/my-image/Dockerfile'.
  * @REPO is the repository name. E.g. '@ntrrg/my-image'. 
  * :TAG is the tag used for the Docker repository. E.g. ':0.1.0'
  * #GIT_REF is the Git reference used as working tree. E.g. '#v0.1.0'

  Note: build instructions only work for Dockerfiles.

If just PATH is given, the Dockerfile directory name will be used as repository
name and 'latest' as tag. Here is a list of ways to override this behavior (in
order of precedence):
  * 'PREFIX' and 'TAG' environment variables.
  * '-p, --prefix' and '-t/--tag' flags.
  * Specific build instruction or configuration file.

Options:
  -c, --config=NAME     Set the configuration file name (.docker-build)
  -f, --file=NAME       Set the Dockerfile name (Dockerfile)
  -g, --git-ref=REF     Use REF as Git working tree
  -h, --help            Show this help message
  -p, --prefix=PREFIX   Prepend PREFIX to the Docker repository name
      --push            Push the image after building it
  -r, --recursive       Look for Dockerfiles in the given directories
                        recursively, this will ignore any configuration file.
  -t, --tag=TAG         Append TAG to the Docker repository name

Configuration file syntax:
  A configuration file is a line-separated list of build instructions. That
  means that a single Dockerfile could be built multiple times with just one
  call of this program. This only works for directories.

Environment variables:
  * 'PREFIX' will be prepended to the Docker repository name.
  * 'TAG' will be appended to the Docker repository name.

Copyright (c) 2018 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

main $@


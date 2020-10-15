#!/bin/sh
# Copyright (c) 2018 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

main() {
  OPTS="c:g:hp:rt:"
  LOPTS="config:,git-ref:,help,prefix:,push,recursive,tag:"

  eval set -- "$(
    getopt --options "$OPTS" --longoptions "$LOPTS" --name "$0" -- "$@"
  )"

  while [ $# -gt 0 ]; do
    case $1 in
      -h | --help )
        show_help
        return
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

  for BI in "$@"; do
    build "$BI"
  done
}

build() {
  if [ -d "$1" ]; then
    if [ $RECURSIVE -eq 0 ]; then
      if [ -f "$1/$CONFIGFILE" ]; then
        # shellcheck disable=SC2013
        for BI in $(cat "$1/$CONFIGFILE"); do
          build "$(readlink --canonicalize-existing "$1")/$BI"
        done
      elif [ -f "$1/$DOCKERFILE" ]; then
        build "$(readlink --canonicalize-existing "$1")/$DOCKERFILE"
      fi
    else
      FILES="$(find "$1" -name "$DOCKERFILE")"

      for BI in $FILES; do
        build "$BI"
      done
    fi
  else
    BI="$1"
    TMP_BI="$BI"

    # shellcheck disable=SC2155
    BI_GIT_REF="$(echo "$TMP_BI" | cut -sd '#' -f 2)"
    if [ -z "$BI_GIT_REF" ]; then
      BI_GIT_REF="$GIT_REF"
    fi

    TMP_BI="$(echo "$TMP_BI" | cut -d '#' -f 1)"

    # shellcheck disable=SC2155
    BI_TAG="$(echo "$TMP_BI" | cut -sd ':' -f 2)"
    if [ -z "$BI_TAG" ]; then
      BI_TAG="$TAG"
    fi

    TMP_BI="$(echo "$TMP_BI" | cut -d ':' -f 1)"

    # shellcheck disable=SC2155
    BI_REPO="$(echo "$TMP_BI" | cut -sd '@' -f 2)"
    # shellcheck disable=SC2155
    BI_DOCKERFILE="$(echo "$TMP_BI" | cut -d '@' -f 1)"
    # shellcheck disable=SC2155
    BI_CTX="$(dirname "$BI_DOCKERFILE")"

    if [ -z "$BI_REPO" ]; then
      BI_REPO="$(basename "$BI_CTX")"
    fi

    # shellcheck disable=SC2155
    BI_IMAGE="$PREFIX$BI_REPO:$BI_TAG"

    if [ -n "$BI_GIT_REF" ]; then
      if [ -n "$(git -C "$BI_CTX" status --porcelain)" ]; then
        echo "the git working directory '$BI_CTX' is not clean"
        echo
        git -C "$BI_CTX" status
        return 1
      fi

      git -C "$BI_CTX" checkout "$BI_GIT_REF"
    fi

    docker build -t "$BI_IMAGE" -f "$BI_DOCKERFILE" "$BI_CTX"

    if [ $PUSH -ne 0 ]; then
      docker push "$BI_IMAGE"
    fi
  fi
}

show_help() {
  BIN_NAME="$(basename "$0")"

  cat <<EOF
$BIN_NAME - Dockerfile build helper. It can build multiple Dockerfiles
with a single command.

Usage: $BIN_NAME [OPTIONS] [PATH | BUILD_INSTRUCTION]...

A build instruction is a sentence that contains the needed information to run
this program in an arbitrary behavior. It's syntax is:

  PATH[@REPO][:TAG][#GIT_REF]

  * PATH is a Dockerfile path. It can't content at symbols (@), colons (:) or
    hashes (#). E.g. '~/my-image/Dockerfile'.
  * @REPO is the repository name. E.g. '@ntrrg/my-image'. 
  * :TAG is the tag used for the Docker repository. E.g. ':0.1.0'
  * #GIT_REF is the Git reference used as working tree. E.g. '#v0.1.0'

If just PATH is given, the Dockerfile directory name will be used as repository
name and 'latest' as tag. Here is a list of ways to override this behavior (in
order of precedence):
  * 'PREFIX' and 'TAG' environment variables.
  * '-p, --prefix' and '-t/--tag' flags.
  * Specific build instruction or configuration file.

Options:
  -c, --config=NAME     Set the configuration file name ($CONFIGFILE)
  -f, --file=NAME       Set the Dockerfile name ($DOCKERFILE)
  -g, --git-ref=REF     Use REF as Git working tree
  -h, --help            Show this help message
  -p, --prefix=PREFIX   Prepend PREFIX to the Docker repository name
      --push            Push the image after building it
  -r, --recursive       Look for Dockerfiles in the given directories
                        recursively, this will ignore any configuration file
  -t, --tag=TAG         Use TAG as Docker repository tag ($TAG)

Configuration file syntax:
  A configuration file is a line-separated list of build instructions. That
  means that a single Dockerfile could be built multiple times with just one
  call of this program. This only works for directories.

Environment variables:
  * 'PREFIX' prependeds its value to the Docker repository name.
  * 'TAG' is the default Docker repository tag. ($TAG)

Copyright (c) 2018 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

CONFIGFILE=".docker-build"
DOCKERFILE="Dockerfile"
GIT_REF=""
PUSH=0
PREFIX="${PREFIX:-}"
RECURSIVE=0
TAG="${TAG:-latest}"

main "$@"


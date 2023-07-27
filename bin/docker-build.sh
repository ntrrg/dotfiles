#!/bin/sh
# Copyright (c) 2018 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -euo pipefail

CONFIGFILE=".docker-build"
DOCKERFILE="Dockerfile"
DRY_RUN=0
GIT_REF=""
PUSH=0
RECURSIVE=0
REPO_PREFIX="${REPO_PREFIX:-""}"
REPO_SUFFIX="${REPO_SUFFIX:-""}"
TAG="${TAG:-""}"
TAG_PREFIX="${TAG_PREFIX:-""}"
TAG_SUFFIX="${TAG_SUFFIX:-""}"

_main() {
	OPTS="c:g:hnp:rt:"
	LOPTS="config:,dry-run,git-ref:,help,prefix:,push,recursive,tag:"

	eval set -- "$(
		getopt --options "$OPTS" --longoptions "$LOPTS" --name "$0" -- "$@"
	)"

	while [ $# -gt 0 ]; do
		case $1 in
		-c | --config)
			CONFIGFILE="$2"
			shift
			;;

		-f | --file)
			DOCKERFILE="$2"
			shift
			;;

		-g | --git-ref)
			GIT_REF="$2"
			shift
			;;

		-h | --help)
			_show_help
			return
			;;

		-n | --dry-run)
			DRY_RUN=1
			;;

		-p | --push)
			PUSH=1
			;;

		-r | --recursive)
			RECURSIVE=1
			;;

		-t | --tag)
			TAG="$2"
			shift
			;;

		--)
			shift
			break
			;;
		esac

		shift
	done

	if [ $# -eq 0 ]; then
		eval set -- "."
	fi

	for BI in "$@"; do
		if [ ! -d "$BI" ]; then
			_build "$BI"
			continue
		fi

		if [ $RECURSIVE -ne 0 ]; then
			FILES="$(find "$BI" -name "$DOCKERFILE" -type f)"

			for BI in $FILES; do
				_build "$BI"
			done

			continue
		fi

		if [ -f "$BI/$CONFIGFILE" ]; then
			for BI in $(cat "$BI/$CONFIGFILE" | xargs -n 1 printf "$BI/%s\n"); do
				_build "$BI"
			done

			continue
		fi

		_build "$BI/$DOCKERFILE"
	done
}

_build() {
	BI="$1"
	BI_ORIG="$BI"

	BI_GIT_REF="${GIT_REF:-"$(echo "$BI" | cut -sd '#' -f 2)"}"
	BI="$(echo "$BI" | cut -d '#' -f 1)"

	BI_TAG="$TAG_PREFIX${TAG:-"$(echo "$BI" | cut -sd ':' -f 2)"}$TAG_SUFFIX"
	BI_TAG="${BI_TAG:-"latest"}"
	BI="$(echo "$BI" | cut -d ':' -f 1)"

	BI_REPO="$(echo "$BI" | cut -sd '@' -f 2)"
	BI_PATH="$(echo "$BI" | cut -d '@' -f 1)"
	BI_CTX="$(dirname "$(realpath "$BI_PATH")")"
	BI_REPO="$REPO_PREFIX${BI_REPO:-"$(basename "$BI_CTX")"}$REPO_SUFFIX"

	BI_IMAGE="$BI_REPO:$BI_TAG"
	log.sh -i "Building '$BI_IMAGE'.. ($BI_ORIG)"

	if [ -n "$BI_GIT_REF" ]; then
		if [ -n "$(git -C "$BI_CTX" status --porcelain)" ]; then
			local _gs="$(git -C "$BI_CTX" status)"
			log.sh -f "the git working directory '$BI_CTX' is not clean\n%s" "$_gs"
		fi

		cmd.sh git -C "$BI_CTX" checkout "$BI_GIT_REF"
	fi

	cmd.sh docker build -t "$BI_IMAGE" -f "$BI_PATH" "$BI_CTX"

	if [ $PUSH -ne 0 ]; then
		cmd.sh docker push "$BI_IMAGE"
	fi
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - Dockerfile build helper.

Usage: $_name [OPTIONS] [DOCKERFILE | BUILD_INSTRUCTION]...

A build instruction is a sentence that contains the needed information to run
this program with arbitrary behavior. It's syntax is:

  PATH[@REPO][:TAG][#GIT_REF]

  * PATH is a Dockerfile path. It can't content at symbols (@), colons (:) or
    hashes (#). E.g. '~/my-image/Dockerfile'.
  * @REPO is the repository name. E.g. '@ntrrg/my-image'. Defaults to the name
    of the directory containing the Dockerfile. 
  * :TAG is the tag used for the Docker repository. E.g. ':0.1.0'. Defaults to
    'latest'.
  * #GIT_REF is the Git reference used as working tree. E.g. '#v0.1.0'.
    Defaults to the current working tree.

Additionally, environment variables and flags may be used. This program
follows this order:

  1. Read build instructions (from arguments or configuration file).
  2. Read environment variables.
  3. Read flags.

Options:
  -c, --config=FILE   Use FILE as configuration file ($CONFIGFILE)
  -f, --file=FILE     Use FILE as default Dockerfile name ($DOCKERFILE)
  -g, --git-ref=REF   Use REF as Git working tree
  -h, --help          Show this help message
  -n, --dry-run       Print what will be done, without doing it
  -p, --push          Push the image after building it
  -r, --recursive     Look for Dockerfiles in the given directories
                      recursively, this will ignore any configuration file
  -t, --tag=TAG       Use TAG as Docker repository tag (latest)

Environment variables:
  * 'REPO_PREFIX' prepends its value to the repository name.
  * 'REPO_SUFFIX' appends its value to the repository name.
  * 'TAG' same as '-t, --tag' flat.
  * 'TAG_PREFIX' prepends its value to the Docker tag.
  * 'TAG_SUFFIX' appends its value to the Docker tag.

Configuration file syntax:
  A configuration file is a line-separated list of build instructions. That
  means that a Dockerfile could be built multiple times with a single call of
  this program. Configuration files only work for directories.

Copyright (c) 2018 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

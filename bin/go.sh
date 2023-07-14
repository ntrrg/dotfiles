#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -euo pipefail

export LOGPREFIX="${LOGPREFIX:-""}${0##*/}: "

_TMPDIR="${TMPDIR:-"/tmp"}"
_GOSH_DATA="${GOSH_DATA:-"${XDG_DATA_HOME:-"$HOME/.local/share"}/go.sh"}"
_GOSH_STATE="${GOSH_STATE:-"${XDG_STATE_HOME:-"$HOME/.local/var"}/go.sh"}"
_GOSH_CACHE="${GOSH_CACHE:-"${XDG_CACHE_HOME:-"$HOME/.cache"}/go.sh"}"
_GOSH_ENVS="${GOSH_ENVS:-"$_GOSH_CACHE"}"

_GO="${GO:-"go"}"
_GO_GIT_MIRROR="${GO_GIT_MIRROR:-"https://go.googlesource.com/go"}"
_GO_MIRROR="${GO_MIRROR:-"https://go.dev/dl"}"
_GO_SRC="${GO_SRC:-"$_GOSH_CACHE/src"}"

_main() {
	local _action="build"

	local _opts="bcdhils"
	local _lopts="bin,build,clear,delete,help,init,list"

	eval set -- "$(
		getopt --options "$_opts" --longoptions "$_lopts" --name "$0" -- "$@"
	)"

	while [ $# -gt 0 ]; do
		case $1 in
		-b | --bin)
			_action="binary"
			;;

		-c | --clear)
			rm -rf \
				${XDG_CACHE_HOME:-"$HOME/.cache"}/go \
				"$_GOSH_CACHE"/* \
				"$_GOSH_ENVS"/*

			return
			;;

		-d | --delete)
			_action="delete"
			;;

		-h | --help)
			_show_help
			return
			;;

		-i | --init)
			mkdir -p "$_GOSH_DATA" "$_GOSH_STATE" "$_GOSH_CACHE" "$_GOSH_ENVS"

			local _GOPATH=""

			if command -v "$_GO" > "/dev/null"; then
				_GOPATH="$("$_GO" env "GOPATH")"
			fi

			if [ -z "$_GOPATH" ]; then
				_GOPATH="${GOPATH:-"$HOME/go"}"
			fi

			echo "export GOPATH=$_GOPATH"
			echo "export PATH=$_GOPATH/bin:$_GOSH_STATE/go/bin:$PATH"
			return
			;;

		-l | --list)
			ls "$_GOSH_ENVS"
			return
			;;

		-s | --build)
			_action="build"
			;;

		--)
			shift
			break
			;;
		esac

		shift
	done

	local _rel=""

	if [ $# -eq 0 ]; then
		_rel="$(_get_latest_release)"
	else
		_rel="$1"
	fi

	local _env="$_GOSH_ENVS/$_rel"

	case $_action in
	binary)
		if [ ! -d "$_env" ]; then
			local _os="$(_get_os)"
			local _arch="$(_get_arch)"
			local _pkg="go$_rel.$_os-$_arch.tar.gz"
			local _dl_pkg="$_TMPDIR/$_pkg"

			if [ ! -f "$_dl_pkg" ]; then
				log.sh "downloading binary release $_rel.."
				wget -cO "$_dl_pkg.part" "$_GO_MIRROR/$_pkg"
				mv "$_dl_pkg.part" "$_dl_pkg"
			fi

			log.sh "decompressing binary release $_rel.. ($_dl_pkg)"
			mkdir "$_env.tmp"
			tar -C "$_env.tmp" --strip-components 1 -xpf "$_dl_pkg"
			mv "$_env.tmp" "$_env"
		fi
		;;

	build)
		if [ ! -d "$_env" ]; then
			local _repo="$_GO_SRC"

			if [ ! -d "$_repo" ]; then
				log.sh "cloning git repository.."
				git clone --bare "$_GO_GIT_MIRROR" "$_repo"
			else
				log.sh "updating git repository.."
				git -C "$_repo" fetch -fpPt origin || true
				git -C "$_repo" gc
			fi

			local _ref="$_rel"

			if [ "$_ref" = "tip" ]; then
				_ref="master"
			elif echo "$_ref" | grep -q "^[1-9]\+\."; then
				_ref="go$_ref"
			fi

			log.sh "generating archive for $_rel from git repository.."
			mkdir "$_env.tmp"
			git -C "$_repo" archive --format tar "$_ref" | tar -C "$_env.tmp" -x
			mv "$_env.tmp" "$_env"
		fi

		if [ ! -x "$_env/bin/go" ]; then
			log.sh "compiling $_rel.."

			export GOROOT_BOOTSTRAP=""

			if command -v "$_GO" > "/dev/null"; then
				GOROOT_BOOTSTRAP="$("$_GO" env "GOROOT")"
			elif [ -z "${GOBOOSTRAP:-""}" ]; then
				local _ref="release-branch.go1.4"

				GOBOOSTRAP=1 CGO_ENABLED=0 _main "$_ref"

				GOROOT_BOOTSTRAP="$_GOSH_ENVS/go$_ref"
			fi

			(unset GOROOT && cd "$_env/src" && ./make.bash)
		fi
		;;

	delete)
		log.sh "deleting release $_rel.. ($_env)"

		if [ ! -d "$_env" ]; then
			log.sh -f "no env for release $_rel"
		fi

		rm -r "$_env"
		return
		;;
	esac

	log.sh "activating release $_rel.."
	rm -f "$_GOSH_STATE/go"
	ln -s "$_env" "$_GOSH_STATE/go"
}

_get_arch() {
	case "$(uname -m)" in
	x86_64 | amd64)
		echo "amd64"
		;;

	x86 | i386 | i486 | i686)
		echo "386"
		;;

	armv8* | arm64 | aarch64)
		echo "arm64"
		;;

	armv6*)
		echo "armv6l"
		;;

	*)
		log.sh -f "cannot define architecture for '$(uname -m)'"
		;;
	esac
}

_get_latest_release() {
	local _resp="$(wget -qO - "$_GO_MIRROR/?mode=json")"
	echo "$_resp" | grep -m 1 "version" | cut -d '"' -f 4 | sed "s/go//"
}

_get_os() {
	echo "linux"
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - manage Go environments.

Usage: $_name [-b | -s] [RELEASE]
   or: $_name -l
   or: $_name -d RELEASE
   or: \$($_name --init)

If no release is given, the latest release will be used.

Options:
  -b, --bin      Download pre-built binaries for the given release
	-c, --clear    Clear data (source code, local releases, etc...)
  -d, --delete   Remove the given release
  -h, --help     Show this help message
  -i, --init     Setup the environment for using $_name
  -l, --list     List all the local releases
  -s, --build    Build given release from source (default)

Environment variables:
  * 'GO_GIT_MIRROR' is the mirror used to clone the Go source code.
  * 'GO_MIRROR' is the mirror used to download the Go assets.
  * 'GO_SRC' points to the directory that holds Go source code.
    ($_GO_SRC)
  * 'GOSH_ENVS' points to the directory that will hold installed Go releases.
    ($_GOSH_ENVS)

For logging options see 'log.sh --help'.

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

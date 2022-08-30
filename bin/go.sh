#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eu

export LOGPREFIX="${LOGPREFIX:-""}${0##*/}: "

_ACTION="build"
_GO="${GO:-"go"}"
_GOSH="${GOSH:-"$HOME/.local/lib/go.sh"}"
_GOENVS="${GOENVS:-"$_GOSH/envs"}"
_GOGITMIRROR="${GOGITMIRROR:-"https://go.googlesource.com/go"}"
_GOMIRROR="${GOMIRROR:-"https://go.dev/dl"}"
_TMPDIR="${TMPDIR:-"/tmp"}"

_main() {
	local _opts="bdhil"
	local _lopts="bin,delete,help,init,list"

	eval set -- "$(
		getopt --options "$_opts" --longoptions "$_lopts" --name "$0" -- "$@"
	)"

	while [ $# -gt 0 ]; do
		case $1 in
		-b | --bin)
			_ACTION="binary"
			;;

		-d | --delete)
			_ACTION="delete"
			;;

		-h | --help)
			_show_help
			return
			;;

		-i | --init)
			mkdir -p "$_GOSH" "$_GOENVS"

			local _GOPATH=""

			if command -v "$_GO" > "/dev/null"; then
				_GOPATH="$("$_GO" env "GOPATH")"
			fi

			if [ -z "$_GOPATH" ]; then
				_GOPATH="${GOPATH:-"$HOME/go"}"
			fi

			echo "export GOPATH=$_GOPATH"
			echo "export PATH=$_GOPATH/bin:$_GOSH/go/bin:$PATH"
			return
			;;

		-l | --list)
			ls "$_GOENVS"
			return
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

	local _env="$_GOENVS/$_rel"

	case $_ACTION in
	binary)
		if [ ! -d "$_env" ]; then
			local _os="$(_get_os)"
			local _arch="$(_get_arch)"
			local _pkg="go$_rel.$_os-$_arch.tar.gz"
			local _dl_pkg="$_TMPDIR/$_pkg"

			log.sh "downloading binary release $_rel.."
			wget -cO "$_dl_pkg" "$_GOMIRROR/$_pkg"

			log.sh "decompressing binary release $_rel.. ($_dl_pkg)"
			mkdir "$_env"
			tar -C "$_env" --strip-components 1 -xpf "$_dl_pkg"
		fi
		;;

	build)
		if [ ! -d "$_env" ]; then
			local _repo="$_GOSH/src"

			if [ ! -d "$_repo" ]; then
				log.sh "cloning go git repository.."
				git clone --bare "$_GOGITMIRROR" "$_repo"
			else
				log.sh "updating go git repository.."
				git -C "$_repo" fetch -fpt origin || true
			fi

			local _ref="$_rel"

			if [ "$_ref" = "tip" ]; then
				_ref="master"
			elif echo "$_ref" | grep -q "^[1-9]\+\."; then
				_ref="go$_ref"
			fi

			log.sh "generating archive for $_rel from git repository.."
			mkdir "$_env"
			git -C "$_repo" archive --format tar "$_ref" | tar -C "$_env" -x
		fi

		if [ ! -x "$_env/bin/go" ]; then
			log.sh "compiling $_rel.."

			export GOROOT_BOOTSTRAP=""

			if command -v "$_GO" > "/dev/null"; then
				GOROOT_BOOTSTRAP="$("$_GO" env "GOROOT")"
			elif [ -z "${GOBOOSTRAP:-""}" ]; then
				local _ref="release-branch.go1.4"

				GOBOOSTRAP=1 CGO_ENABLED=0 _main "$_ref"

				GOROOT_BOOTSTRAP="$_GOENVS/go$_ref"
			fi

			(unset GOROOT && cd "$_env/src" && ./make.bash)
		fi
		;;

	delete)
		log.sh "deleting release $_rel.. ($_env)"

		if [ ! -d "$_env" ]; then
			log.sh -e "no env for release $_rel"
			return 1
		fi

		rm -r "$_env"
		return
		;;
	esac

	log.sh "activating release $_rel.."
	rm -f "$_GOSH/go"
	ln -s "$_env" "$_GOSH/go"
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
		exit 1
		;;
	esac
}

_get_latest_release() {
	wget -qO - "$_GOMIRROR/?mode=json" |
		grep -m 1 "version" |
		cut -d '"' -f 4 |
		sed "s/go//"
}

_get_os() {
	echo "linux"
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - manage Go environments.

Usage: $_name [-b] [RELEASE]
   or: $_name -l
   or: $_name -d RELEASE
   or: \$($_name --init)

If no release is given, the latest release will be used.

Options:
  -b, --bin      Download pre-built binaries for the given release
  -d, --delete   Remove the given release
  -h, --help     Show this help message
  -i, --init     Setup the environment for using $_name
  -l, --list     List all the local releases

Environment variables:
  * 'GOENVS' points to the directory that will hold insalled Go releases.
    ($_GOENVS)
  * 'GOGITMIRROR' is the mirror used to clone the Go source code.
  * 'GOMIRROR' is the mirror used to download the Go assets.
  * 'GOSH' points to the directory that will hold go.sh utilities.
    ($_GOSH)

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -euo pipefail

export LOGPREFIX="${LOGPREFIX:-""}${0##*/}: "

_GOSH_DATA="${GOSH_DATA:-"${XDG_DATA_HOME:-"$HOME/.local/share"}/go.sh"}"
_GOSH_STATE="${GOSH_STATE:-"${XDG_STATE_HOME:-"$HOME/.local/var"}/go.sh"}"
_GOSH_CACHE="${GOSH_CACHE:-"${XDG_CACHE_HOME:-"$HOME/.cache"}/go.sh"}"
_GOSH_ENVS="${GOSH_ENVS:-"$_GOSH_STATE"}"

_GO="${GO:-"go"}"
_GO_GIT_MIRROR="${GO_GIT_MIRROR:-"https://go.googlesource.com/go"}"
_GO_MIRROR="${GO_MIRROR:-"https://go.dev/dl"}"
_GO_SRC="${GO_SRC:-"$_GOSH_CACHE/src"}"

_main() {
	local _action="source"

	local _opts="bcdhiLlps"
	local _lopts="bin,clear,deinit,delete,help,init,list,prefix,releases,source"

	eval set -- "$(
		getopt --options "$_opts" --longoptions "$_lopts" --name "$0" -- "$@"
	)"

	while [ $# -gt 0 ]; do
		case $1 in
		-b | --bin)
			_action="binary"
			;;

		-c | --clear)
			_action="clear"
			;;

		-d | --delete)
			_action="delete"
			;;

		-h | --help)
			_show_help
			return
			;;

		-i | --init)
			_action="init"
			;;

		-L | --releases)
			_action="releases"
			;;

		-l | --list)
			_action="list"
			;;

		-p | --prefix)
			_action="prefix"
			;;

		-s | --source)
			_action="source"
			;;

		--deinit)
			_action="deinit"
			;;

		--)
			shift
			break
			;;
		esac

		shift
	done

	case $_action in
	clear)
		rm -rf \
			"${GOPATH:-"$HOME/go"}/pkg" "${XDG_CACHE_HOME:-"$HOME/.cache"}/go" \
			"$_GOSH_CACHE"/*
		;;

	deinit)
		local _bin_path="$(
			echo "$(_go_path)/bin:$_GOSH_DATA/go/bin:" |
				sed 's/\//\\\//g' |
				sed 's/\./\\./g'
		)"

		echo "unset GOPATH"
		echo "export PATH=$(echo "$PATH" | sed "s/$_bin_path//g")"
		;;

	delete)
		if [ $# -eq 0 ]; then
			log.sh -f "no release given"
		fi

		local _rel="$1"
		local _env="$_GOSH_ENVS/$_rel"

		log.sh "deleting release $_rel.. ($_env)"

		rm -r "$_env"
		;;

	init)
		local _GOPATH="$(_go_path)"

		mkdir -p "$_GOSH_DATA" "$_GOSH_STATE" "$_GOSH_CACHE" "$_GOSH_ENVS"
		echo "export GOPATH=$_GOPATH"
		echo "export PATH=$_GOPATH/bin:$_GOSH_DATA/go/bin:$PATH"
		;;

	list)
		ls "$_GOSH_ENVS"
		;;

	prefix)
		local _env=""

		if [ $# -eq 0 ]; then
			_env="$_GOSH_DATA/go"
		else
			_env="$_GOSH_ENVS/$1"
		fi

		if [ ! -d "$_env" ]; then
			log.sh -f "cannot find given release"
		fi

		echo "$_env"
		;;

	releases)
		local _output=""
		local _rel=""

		for _rel in $(_releases); do
			_output="$_rel
$_output"
		done

		echo "$_output" | sed '/^$/d'
		;;

	binary)
		local _rel=""

		if [ $# -eq 0 ]; then
			_rel="$(_latest_release)"
		else
			_rel="$1"
		fi

		local _env="$_GOSH_ENVS/$_rel"

		if [ ! -d "$_env" ]; then
			local _os="$(_host_os)"
			local _arch="$(_host_arch)"
			local _pkg="go$_rel.$_os-$_arch.tar.gz"
			local _dl_pkg="$_GOSH_CACHE/$_pkg"

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

		_activate "$_rel"
		;;

	source)
		local _rel=""

		if [ $# -eq 0 ]; then
			_rel="$(_latest_release)"
		else
			_rel="$1"
		fi

		local _env="$_GOSH_ENVS/$_rel"

		if [ ! -d "$_env" ]; then
			local _repo="$_GO_SRC"

			if [ ! -d "$_repo" ]; then
				log.sh "cloning git repository.."
				git clone --bare "$_GO_GIT_MIRROR" "$_repo"
			else
				log.sh "updating git repository.."
				git -C "$_repo" fetch -fpPt origin || true
			fi

			local _ref="$_rel"

			if [ "$_ref" = "tip" ]; then
				_ref="master"
			elif echo "$_ref" | grep -q "^[1-9]\+\."; then
				_ref="go$_ref"
			fi

			log.sh "generating archive for $_rel from git repository.."
			[ ! -d "$_env.tmp" ] && mkdir "$_env.tmp"
			_git_archive "$_repo" "$_ref" | tar -C "$_env.tmp" -x
			mv "$_env.tmp" "$_env"
		fi

		if [ ! -x "$_env/bin/go" ]; then
			log.sh "compiling $_rel.."

			if [ -f "$_env/src/cmd/dist/main.go" ]; then
				if command -v "$_GO" > "/dev/null"; then
					export GOROOT_BOOTSTRAP="$("$_GO" env "GOROOT")"
				else
					local _ref="release-branch.go1.4"
					CGO_ENABLED=0 _main "$_ref"
					export GOROOT_BOOTSTRAP="$_GOSH_ENVS/$_ref"

					if [ -f "$_env/src/cmd/dist/notgo117.go" ]; then
						local _ref="release-branch.go1.17"
						_main "$_ref"
						export GOROOT_BOOTSTRAP="$_GOSH_ENVS/$_ref"
					fi
				fi
			fi

			(unset GOROOT && cd "$_env/src" && ./make.bash)
		fi

		_activate "$_rel"
		;;
	esac
}

_activate() {
	local _rel=""

	if [ $# -eq 0 ]; then
		log.sh -f "no release given"
	else
		_rel="$1"
	fi

	local _env="$_GOSH_ENVS/$_rel"

	if [ ! -d "$_env" ]; then
		log.sh -f "cannot find given release"
	fi

	log.sh "activating release $_rel.."
	rm -f "$_GOSH_DATA/go"
	ln -s "$_env" "$_GOSH_DATA/go"
}

_git_archive() {
	local _repo="${1:-"."}"
	local _ref="${2:-"HEAD"}"

	for _ref in "$_ref" "origin/$_ref"; do
		git -C "$_repo" archive --format tar "$_ref" || continue
		return
	done

	log.sh -f "%s is not a valid git object name" "$_ref"
}

_go_path() {
	if [ -n "${GOPATH:-""}" ]; then
		echo "$GOPATH"
	elif command -v "$_GO" > "/dev/null"; then
		"$_GO" env "GOPATH"
	else
		echo "$HOME/go"
	fi
}

_host_arch() {
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

_host_os() {
	echo "linux"
}

_latest_release() {
	local _releases="$(_releases)"
	echo "$_releases" | head -n 1
}

_releases() {
	local _resp="$(wget -qO - "$_GO_MIRROR/?mode=json&include=all")"
	echo "$_resp" | grep "version" | uniq -u | cut -d '"' -f 4 | sed "s/go//"
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - manage Go environments.

Usage: $_name [-b | -s] [RELEASE]
   or: $_name -L
   or: $_name -l
   or: $_name -p [RELEASE]
   or: $_name -d RELEASE
   or: \$($_name --init)
   or: \$($_name --deinit)

If no release is given, the latest release will be used.

Options:
  -b, --bin        Download pre-built binaries for the given release
	-c, --clear      Clear cache data (build cache, binary downloads, etc...)
  -d, --delete     Remove the given release
  -h, --help       Show this help message
  -i, --init       Setup the environment for using $_name
  -L, --releases   List available releases
  -l, --list       List local releases
  -p, --prefix     Print release prefix
  -s, --source     Build given release from source (default)

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

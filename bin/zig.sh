#!/bin/sh
# Copyright (c) 2023 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -euo pipefail

export LOGPREFIX="${LOGPREFIX:-""}${0##*/}: "

_ZIGSH_DATA="${ZIGSH_DATA:-"${XDG_DATA_HOME:-"$HOME/.local/share"}/zig.sh"}"
_ZIGSH_STATE="${ZIGSH_STATE:-"${XDG_STATE_HOME:-"$HOME/.local/var"}/zig.sh"}"
_ZIGSH_CACHE="${ZIGSH_CACHE:-"${XDG_CACHE_HOME:-"$HOME/.cache"}/zig.sh"}"
_ZIGSH_ENVS="${ZIGSH_ENVS:-"$_ZIGSH_STATE"}"

_ZIG="${ZIG:-"zig"}"
_ZIG_BUILDS_MIRROR="${ZIG_MIRROR:-"https://ziglang.org/builds"}"
_ZIG_GIT_MIRROR="${ZIG_GIT_MIRROR:-"https://github.com/ziglang/zig"}"
_ZIG_MIRROR="${ZIG_MIRROR:-"https://ziglang.org/download"}"
_ZIG_SRC="${ZIG_SRC:-"$_ZIGSH_CACHE/src"}"

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
		rm -rf "${XDG_CACHE_HOME:-"$HOME/.cache"}/zig" "$_ZIGSH_CACHE"/*
		;;

	deinit)
		local _bin_path="$(
			echo "$_ZIGSH_DATA/zig:" |
				sed 's/\//\\\//g' |
				sed 's/\./\\./g'
		)"

		echo "export PATH=$(echo "$PATH" | sed "s/$_bin_path//g")"
		;;

	delete)
		if [ $# -eq 0 ]; then
			log.sh -f "no release given"
		fi

		local _rel="$1"
		local _env="$_ZIGSH_ENVS/$_rel"

		log.sh "deleting release $_rel.. ($_env)"

		rm -r "$_env"
		;;

	init)
		mkdir -p "$_ZIGSH_DATA" "$_ZIGSH_STATE" "$_ZIGSH_CACHE" "$_ZIGSH_ENVS"
		echo "export PATH=$_ZIGSH_DATA/zig:$PATH"
		;;

	list)
		ls "$_ZIGSH_ENVS"
		;;

	prefix)
		local _env=""

		if [ $# -eq 0 ]; then
			_env="$_ZIGSH_DATA/zig"
		else
			_env="$_ZIGSH_ENVS/$1"
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

		local _env="$_ZIGSH_ENVS/$_rel"

		if [ ! -d "$_env" ]; then
			local _os="$(_host_os)"
			local _arch="$(_host_arch)"
			local _pkg="zig-$_os-$_arch-$_rel.tar.xz"
			local _dl_pkg="$_ZIGSH_CACHE/$_pkg"
			local _mirror="$_ZIG_MIRROR/$_rel"

			if echo "$_rel" | grep -q "[-]dev[.]"; then
				_mirror="$_ZIG_BUILDS_MIRROR"
			fi

			if [ ! -f "$_dl_pkg" ]; then
				log.sh "downloading binary release $_rel.."
				wget -O "$_dl_pkg.part" "$_mirror/$_pkg"

				if command -v minisign > "/dev/null"; then
					wget -O "$_dl_pkg.part.minisig" "$_mirror/$_pkg.minisig"
					minisign -Vm "$_dl_pkg.part" -P 'RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U'
				fi

				mv "$_dl_pkg.part" "$_dl_pkg"
			fi

			log.sh "decompressing binary release $_rel.. ($_dl_pkg)"
			rm -rf "$_env.tmp"
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

		local _env="$_ZIGSH_ENVS/$_rel"

		if [ -d "$_env.src" ]; then
			mv "$_env.src" "$_env"
		fi

		if [ ! -d "$_env" ]; then
			local _repo="$_ZIG_SRC"

			if [ ! -d "$_repo" ]; then
				log.sh "cloning git repository.."
				git clone --bare "$_ZIG_GIT_MIRROR" "$_repo"
			else
				log.sh "updating git repository.."
				git -C "$_repo" fetch -fpPt origin || true
			fi

			local _ref="$_rel"

			if echo "$_ref" | grep -q "^[0-9]\+\.[0-9]\+\$"; then
				_ref="$_ref.x"
			elif echo "$_ref" | grep -q "[-]dev[.]"; then
				_ref="$(echo "$_ref" | cut -d '+' -f 2 | cut -d '.' -f 1)"
			fi

			log.sh "generating archive for $_rel from git repository.."
			[ ! -d "$_env.tmp" ] && mkdir "$_env.tmp"
			_git_archive "$_repo" "$_ref" | tar -C "$_env.tmp" -x
			mv "$_env.tmp" "$_env"
		fi

		if [ ! -x "$_env/zig" ]; then
			log.sh "compiling $_rel.."

			local _old_pwd="$PWD"
			cd "$_env"

			mkdir -p "build"
			cd "build"

			if ! command -v "$_ZIG" > "/dev/null"; then
				log.sh "bootstraping zig.."

				cmake \
					-DCMAKE_BUILD_TYPE="Release" \
					-DZIG_USE_LLVM_CONFIG="ON" \
					-DZIG_STATIC="ON" \
					-DZIG_NO_LIB="ON" \
					-DZIG_LIB_DIR="$PWD/../lib" \
					-DZIG_HOST_TARGET_TRIPLE="$(_host_arch)-$(_host_os)-musl" \
					-DZIG_TARGET_TRIPLE="native" \
					-DZIG_TARGET_MCPU="native" \
					".."

				make -j "$(nproc)" install
				_ZIG="stage3/bin/zig"
			fi

			log.sh "compiling with zig v$("$_ZIG" version).."

			"$_ZIG" build \
				--prefix "stage4" -Dflat \
				-Doptimize="ReleaseFast" -Dstrip \
				-Denable-llvm -Dstatic-llvm \
				-Dtarget="native" \
				-Dcpu="native" \
				-Duse-zig-libcxx \
				-Dno-autodocs \
				-Dversion-string="$_rel"

			log.sh "building documentation.."

			"$_ZIG" build docs \
				--prefix "stage4" -Dflat \
				-Doptimize="ReleaseFast" -Dstrip \
				-Dtarget="native-native-musl" \
				-Dcpu="native" \
				-Dversion-string="$_rel"

			cd "$_old_pwd"
			mv "$_env" "$_env.src"
			mv "$_env.src/build/stage4" "$_env"
			rm -rf "$_env.src"
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

	local _env="$_ZIGSH_ENVS/$_rel"

	if [ ! -d "$_env" ]; then
		log.sh -f "cannot find given release"
	fi

	log.sh "activating release $_rel.."
	rm -f "$_ZIGSH_DATA/zig"
	ln -s "$_env" "$_ZIGSH_DATA/zig"
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

_host_arch() {
	case "$(uname -m)" in
	x86_64 | amd64)
		echo "x86_64"
		;;

	x86 | i386 | i486 | i686)
		echo "x86"
		;;

	armv8* | arm64 | aarch64)
		echo "aarch64"
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
	local _resp="$(wget -qO - "$_ZIG_MIRROR/index.json")"

	echo "$_resp" |
		grep '^\s\{2\}"\|version' |
		grep -v 'master' |
		sed 's/"version"://' |
		cut -d '"' -f 2
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - manage Zig environments.

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
  * 'ZIG_BUILDS_MIRROR' is the mirror used to download the Zig dev assets.
  * 'ZIG_GIT_MIRROR' is the mirror used to clone the Zig source code.
  * 'ZIG_MIRROR' is the mirror used to download the Zig assets.
  * 'ZIG_SRC' points to the directory that holds Zig source code.
    ($_ZIG_SRC)
  * 'ZIGSH_ENVS' points to the directory that will hold Zig releases.
    ($_ZIGSH_ENVS)

For logging options see 'log.sh --help'.

Copyright (c) 2023 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

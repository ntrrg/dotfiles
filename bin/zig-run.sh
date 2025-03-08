#!/bin/sh
# Copyright (c) 2025 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -euo pipefail

export LOGPREFIX="${LOGPREFIX:-""}${0##*/}: "

_ZIG="${ZIG:-"zig"}"
_ZIG_CACHE="${ZIG_CACHE:-"${XDG_CACHE_HOME:-"$HOME/.cache"}/zig"}"

_ZIG_RUN_CACHE="$_ZIG_CACHE/run"

_main() {
	if [ $# -eq 0 ]; then
		log.sh -f "no arguments given"
	fi

	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		_show_help
		return
	fi

	if [ "$1" = "-c" ] || [ "$1" = "--clear" ]; then
		rm -rf "$_ZIG_RUN_CACHE"/*
		return
	fi

	local _zig_flags=""

	while [ $# -gt 0 ]; do
		if [ "$1" = "--" ]; then
			shift
			break
		fi

		local _arg="$1"

		if echo "$_arg" | grep -q '\s'; then
			_arg="'$_arg'"
		fi

		_zig_flags="$_zig_flags $_arg"
		shift
	done

	if [ $# -eq 0 ]; then
		log.sh -f "no source given"
	fi

	local _source="$1"
	shift

	if [ "$_source" = "-" ]; then
		_source="$(mktemp -ut zig-run-XXXXXX).zig"
		cat - > "$_source"
	fi

	local _zig_flags_hash="$(echo "$_zig_flags" | sha1sum | _hash_from_sum)"
	local _source_hash="$(sha256sum "$_source" | _hash_from_sum)"
	local _hash="$(echo "$_zig_flags_hash $_source_hash" | sha1sum | _hash_from_sum)"

	mkdir -p "$_ZIG_RUN_CACHE"
	local _output="$_ZIG_RUN_CACHE/$_hash"

	if [ ! -x "$_output" ]; then
		local _cmd="$_ZIG build-exe $_zig_flags -femit-bin='$_output'"

		if ! echo "$_zig_flags" | grep -q "\-Mroot="; then
			_cmd="$_cmd '$_source'"
		fi

		cmd.sh sh -c "$_cmd"
	fi

	"$_output" "$@"
}

_hash_from_sum() {
	cat - | tr -s ' ' ' ' | cut -d ' ' -f 1
}

_show_help() {
	local _name="${0##*/}"

	cat << EOF
$_name - run Zig code as scripts.

This utility is not meant to replace 'zig run', but to be used for shebangs.

Usage: $_name [ZIG_FLAGS] -- {SOURCE_FILE | -} [ARGS]...

If - is given as source file, STDIN will be used.

Options:
  -c, --clear   Deletes binaries cache
  -h, --help    Show this help message

  For logging options see 'log.sh --help'.

Environment variables:
  - 'ZIG' is the Zig compiler used.
  - 'ZIG_CACHE' points to the directory that holds Zig global cache. Binaries
    will be stored in the child 'run' directory.

Examples:

  - Simple execution:

    //usr/bin/env zig-run.sh -- "\$0" "\$@"; exit;

  - With Zig flags:

    //usr/bin/env zig-run.sh -target native -mcpu native -O ReleaseSmall -- "\$0" "\$@"; exit;

  - With dependencies:

    //usr/bin/env zig-run.sh --dep ntz -Mroot="\$0" -Mntz="\$HOME/Code/Zig/ntz/src/ntz.zig" -- "\$0" "\$@"; exit;

  - Complex execution:

    //usr/bin/env zig-run.sh \${ZIG_FLAGS:--target native -mcpu native -O ReleaseSmall} --dep ntz -Mroot="\$0" -Mntz="\$HOME/Code/Zig/ntz/src/ntz.zig" -- "\$0" "\$@"; exit;

Copyright (c) 2025 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

_main "$@"

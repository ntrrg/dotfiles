#!/bin/sh

set -eo pipefail

_CONKY_DIR="${CONKY_DIR:-"$HOME/.local/etc/conky"}"

_main() {
	local _sleep="${SLEEP:-5}"

	echo "Wating for $_sleep seconds.."
	sleep $_sleep

	. "$_CONKY_DIR/system-info.sh"

	CONFS="$(find "$_CONKY_DIR" -iname "conky-*.conf" | grep -v "*/_conky-*.conf")"

	for CONF in $CONFS; do
		_conky -c "$CONF" -d
	done

	_conky -c "$_CONKY_DIR/conky.conf" "$@"
}

_conky() {
  CONF="$2"
  shift; shift

  NEW_CONF="$(mktemp -ut conky-conf-XXXXXX).conf"
  cat "$_CONKY_DIR/base.conf" | head -n -2 > "$NEW_CONF"
  cat "$CONF" | tail -n +2 >> "$NEW_CONF"
  conky -c "$NEW_CONF" "$@"
}

_main "$@"

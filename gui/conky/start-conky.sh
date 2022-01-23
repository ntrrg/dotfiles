#!/bin/sh

set -e

_conky() {
  CONF="$2"
  shift; shift

  NEW_CONF="$(mktemp -ut conky-conf-XXXXXX).conf"
  cat "$CONKY_DIR/base.conf" | head -n -2 > "$NEW_CONF"
  cat "$CONF" | tail -n +2 >> "$NEW_CONF"
  conky -c "$NEW_CONF" "$@"
}

SLEEP="${SLEEP:-20}"
CONKY_DIR="${CONKY_DIR:-"$HOME/.config/conky"}"

killall conky 2> /dev/null || true
echo "Wating for $SLEEP seconds.."
sleep "$SLEEP"

. "$CONKY_DIR/conky.env"

CONFS="$(find "$CONKY_DIR" -iname "conky-*.conf" | grep -v "*/_conky-*.conf")"

for CONF in $CONFS; do
  _conky -c "$CONF" -d
done

_conky -c "$CONKY_DIR/conky.conf" "$@"


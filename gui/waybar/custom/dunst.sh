#!/bin/bash

set -euo pipefail

_icon=""
_count=$(($(dunstctl count waiting) + $(dunstctl count displayed)))
_class=""

if [ $_count -gt 0 ]; then
	_icon="󱅫"
	_class="has-notifications"
elif dunstctl is-paused | grep -q "true"; then
	_icon="󱏧"
	_class="is-paused"
else
	_icon="󰂚"
fi

printf '{"text": "%s", "tooltip": "You have %s notifications", "class": "%s"}' \
	"$_icon" \
	"$_count" \
	"$_class"

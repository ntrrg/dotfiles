#!/bin/sh
# Copyright (c) 2020 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -eo pipefail

_drivers="$(find "/sys/class/backlight/" -mindepth 1 -maxdepth 1)"
_driver="${1:-"$(echo "$_drivers" | head -n 1)"}"

_current="$(cat "$_driver/brightness")"
_max="$(cat "$_driver/max_brightness")"
_percent="$(echo "$_current * 100 / $_max" | bc)"

printf '{"percentage": %s, "tooltip": "%s"}' "$_percent" "$_percent%"

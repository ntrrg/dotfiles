#!/bin/bash

set -euo pipefail

_device="${1:-"battery_BAT0"}"
_info="$(upower -i /org/freedesktop/UPower/devices/$_device)"
_rate="$(echo "$_info" | grep "energy-rate:" | grep -oE '[0-9]+(\.[0-9]+)?')"
_current="$(echo "$_info" | grep "energy:" | grep -oE '[0-9]+(\.[0-9]+)?')"
_percent="$(echo "$_rate * 100 / $_current" | bc)"

printf '{"percentage": %s, "tooltip": "%s"}' "$_percent" "$_rate W"

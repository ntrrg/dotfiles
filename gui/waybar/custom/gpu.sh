#!/bin/bash

set -euo pipefail

_device="${1:-"/sys/class/hwmon/hwmon0"}"
_percent="$(cat "$_device/device/gpu_busy_percent")"

printf '{"percentage": %s, "tooltip": "%s"}' "$_percent" "$_percent%"

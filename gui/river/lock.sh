#!/bin/sh

set -euo pipefail

_RIVER_WALLPAPERS="${RIVER_WALLPAPERS:-"$HOME/Pictures/Wallpapers/Landscape"}"

exec swaylock -c 000000 -F -k -l -s fill -i "$(find "$_RIVER_WALLPAPERS" | shuf -n 1)"

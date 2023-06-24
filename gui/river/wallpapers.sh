#!/bin/sh

set -euo pipefail

_RIVER_WALLPAPERS="${RIVER_WALLPAPERS:-"$HOME/Pictures/Wallpapers/Landscape"}"
_RIVER_WALLPAPERS_INTERVAL="${RIVER_WALLPAPERS_INTERVAL:-"30s"}"

while true; do
	for _wallpaper in $_RIVER_WALLPAPERS/*; do
		pkill swaybg || true
		ps -a | grep -q '\sriver$' || log.sh -f "river is not running"
		riverctl spawn "swaybg --output '*' --mode fill --image '$_wallpaper'" 2> /dev/null
		sleep $_RIVER_WALLPAPERS_INTERVAL
	done
done

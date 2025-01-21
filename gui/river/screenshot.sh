#!/bin/sh

set -euo pipefail

_mode="${1:-""}"

if [ -z "$_mode" ]; then
	_mode=$(
		echo "full
screen
window
region
point
color" | rofi -dmenu -l 7 -p "Screenshot mode:"
	)
fi

case "$_mode" in
color)
	exec grim -g "$(slurp -p)" -t ppm - |
		convert - txt:- |
		tail -n 1 |
		tail -c +6 |
		tr -s ' ' ' ' |
		wl-copy -n
	;;

point)
	exec grim -g "$(slurp -p)" - | swappy -f -
	;;

region)
	exec grim -g "$(slurp -c "#427819ff" -w 3)" - | swappy -f -
	;;

window)
	exec grim -c -o "$(slurp -o -f "%o")" - | swappy -f -
	;;

screen)
	exec grim -c -o "$(slurp -o -f "%o")" - | swappy -f -
	;;

full | *)
	exec grim -c - | swappy -f -
	;;
esac

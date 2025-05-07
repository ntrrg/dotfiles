#!/bin/sh

set -eu

_dirs="
	$HOME/.local
	$HOME/.local/bin
	$HOME/.local/etc:$HOME/.config
	$HOME/.local/share
	$HOME/.local/share/fonts:$HOME/.fonts
	$HOME/.local/share/icons:$HOME/.icons
	$HOME/.local/share/themes:$HOME/.themes
	$HOME/.local/var:$HOME/.var
	$HOME/.local/var/cache:$HOME/.cache
"

for _pair in $_dirs; do
	_dir="$(echo "$_pair" | cut -d ':' -f 1)"
	_target="$(echo "$_pair" | cut -d ':' -f 2)"

	[ -d "$_dir" ] || mkdir -p "$_dir"

	if [ "$_dir" == "$_target" ]; then
		continue
	fi

	if [ -e "$_target" ]; then
		if [ -L "$_target" ]; then
			rm "$_target"
		elif [ -d "$_target" ]; then
			mv "$_target"/* "$_dir/"
			rmdir "$_target"
		else
			mv "$_target" "$_target.bak"
		fi
	fi

	ln -s "$_dir" "$_target"
done

#!/bin/sh

set -eu

mkdir -p "$HOME/.local"

for _pair in "$HOME/.local/bin" "$HOME/.local/etc:$HOME/.config" "$HOME/.local/share" "$HOME/Fonts:$HOME/.local/share/fonts" "$HOME/Icons:$HOME/.local/share/icons" "$HOME/Themes:$HOME/.local/share/themes" "$HOME/.local/var:$HOME/.var" "$HOME/.local/var/cache:$HOME/.cache"; do
	_dir="$(echo "$_pair" | cut -d ':' -f 1)"
	_target="$(echo "$_pair" | cut -d ':' -f 2)"

	mkdir -p "$_dir"

	if [ "$_dir" != "$_target" ]; then
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
	fi
done

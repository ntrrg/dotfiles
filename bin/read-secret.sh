#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

_stty_state="$(stty -g)"

_on_exit() {
	local _err=$?

	stty "$_stty_state"
	trap - INT
	trap - EXIT
	return $_err
}

trap true INT
trap _on_exit EXIT

stty -echo
IFS= read -r SECRET
printf "$SECRET"

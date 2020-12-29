#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

_enable_echo() {
	stty echo
}

trap _enable_echo EXIT
stty -echo
IFS= read -r SECRET
_enable_echo
trap - EXIT
printf "$SECRET"

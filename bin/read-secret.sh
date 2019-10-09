#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

enable_echo() {
  stty echo
}

trap enable_echo EXIT
stty -echo
IFS= read -r PASSWD
enable_echo
trap - EXIT
echo "$PASSWD"


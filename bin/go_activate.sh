#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  cat <<EOF
$0 - setup a Go environment.

Usage: $0 [RELEASE]

If no release is given, the latest release will be used.

By default, Go uses '~/go' as workspace, this could be changed by doing:
  * ln -sf /path/to/myworkspace ~/go
  * export GOPATH=/path/to/myworkspace

Options:
  -h, --help   Show this help message.

Environment variables:
  * 'GOARCH' is the Go binary architecture to be used. (amd64)
  * 'GOENVS' points to the directory that will hold the Go files of any other
    releases. (~/.local/share/go)
  * 'GOMIRROR' is the mirror used to download the Go binary releases.
    (https://dl.google.com/go)
  * 'GOPATH' is the Go workspace path. (~/go)

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

  exit 1
fi

ga_main() {
  local GOARCH="${GOARCH:-amd64}"
  local GOENVS="${GOENVS:-$HOME/.local/share/go}"
  local GOMIRROR="${GOMIRROR:-https://dl.google.com/go}"
  local GORELEASE="${1:-$(ga_get_latest_release)}"

  export GOPATH="${GOPATH:-$HOME/go}"
  export GOROOT="$GOENVS/go$GORELEASE.linux-$GOARCH"

  if [ ! -d "$GOROOT" ]; then
    local PACKAGE="go$GORELEASE.linux-$GOARCH.tar.gz"
    wget -cO "/tmp/$PACKAGE" "$GOMIRROR/$PACKAGE"
    mkdir -p "$GOROOT"
    tar -C "$GOROOT" --strip-components 1 -xpf "/tmp/$PACKAGE"
  fi

  export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
}

ga_clean_env() {
  local ERR_CODE=$?

  trap - INT TERM EXIT
  unset -f ga_clean_env
  unset -f ga_main
  unset -f ga_get_latest_release

  if [ $ERR_CODE -eq 0 ]; then
    return $ERR_CODE
  fi

  export PATH="$(
    echo "$PATH" |
    sed "s/$(echo "$GOROOT/bin:" | sed -re "s/\//\\\\\//g")//" |
    sed "s/$(echo "$GOPATH/bin:" | sed -re "s/\//\\\\\//g")//"
  )"

  return 1
}

ga_get_latest_release() {
  wget -qO - 'https://golang.org/dl/?mode=json' |
    grep -m 1 "version" |
    cut -d '"' -f 4 |
    sed "s/go//"

  return $?
}

trap ga_clean_env INT TERM EXIT
ga_main $@
ga_clean_env


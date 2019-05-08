#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

go_env_main() {
  case $1 in
    -h | --help )
      go_env_show_help
      ;;

    -d | --delete )
      go_env_delete "$2"
      ;;

    -l | --list )
      ls "$GOENVS"
      ;;

    * )
      go_env_create "$1"
      ;;
  esac
}

go_env_clean_env() {
  set +e
  trap - INT TERM EXIT
  unset -f go_env_clean_env
  unset -f go_env_create
  unset -f go_env_delete
  unset -f go_env_get_arch
  unset -f go_env_get_latest_release
  unset -f go_env_main
  unset -f go_env_on_trap
  unset -f go_env_show_help
}

go_env_create() {
  local GORELEASE="${1:-$(go_env_get_latest_release)}"
  local GOENV="go$GORELEASE.linux-$GOARCH"

  export GOROOT="$GOENVS/$GOENV"

  if [ ! -d "$GOROOT" ]; then
    local PACKAGE="$GOENV.tar.gz"
    wget -cO "/tmp/$PACKAGE" "$GOMIRROR/$PACKAGE"
    mkdir -p "$GOROOT"
    tar -C "$GOROOT" --strip-components 1 -xpf "/tmp/$PACKAGE"
  fi

  export GOPATH="${GOPATH:-$HOME/go}"
  export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
}

go_env_delete() {
  local GORELEASE="${1:-$(go_env_get_latest_release)}"
  local GOENV="go$GORELEASE.linux-$GOARCH"
  local GOROOT="$GOENVS/$GOENV"

  rm -r "$GOROOT"
}

go_env_get_arch() {
  case "$(uname -m)" in
    x86_64 | amd64 )
      echo "amd64"
      ;;

    x86 | i386 | i486 | i686 )
      echo "386"
      ;;

    armv8* | arm64 | aarch64 )
      echo "arm64"
      ;;

    armv6* )
      echo "armv6l"
      ;;

    * )
      echo "can't define Go architecture for $GOARCH"
      return 1
      ;;
  esac
}

go_env_get_latest_release() {
  wget -qO - 'https://golang.org/dl/?mode=json' |
    grep -m 1 "version" |
    cut -d '"' -f 4 |
    sed "s/go//"
}

go_env_on_trap() {
  local ERR_CODE=$?

  go_env_clean_env

  PATH="$(
    echo "$PATH" |
    sed "s/$(echo "$GOROOT/bin:" | sed -re "s/\//\\\\\//g")//" |
    sed "s/$(echo "$GOPATH/bin:" | sed -re "s/\//\\\\\//g")//"
  )"

  export PATH
  return $ERR_CODE
}

go_env_show_help() {
  cat <<EOF
$0 - manage Go environments.

Usage: $0 [RELEASE]
   or: $0 -l
   or: $0 -d RELEASE

If no release is given, the latest release will be used.

By default, Go uses '~/go' as workspace, this could be changed by doing:
  * ln -sf /path/to/myworkspace ~/go
  * export GOPATH=/path/to/myworkspace

Options:
  -d, --delete=RELEASE   Remove the given release
  -h, --help             Show this help message
  -l, --list             List all the local releases

Environment variables:
  * 'GOARCH' is the Go binary architecture to be used. ($GOARCH)
  * 'GOENVS' points to the directory that will hold the Go files of any other
    releases. ($GOENVS)
  * 'GOMIRROR' is the mirror used to download the Go binary releases.
    ($GOMIRROR)
  * 'GOPATH' is the Go workspace path. (~/go)

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

GOARCH="${GOARCH:-$(go_env_get_arch)}"
GOENVS="${GOENVS:-$HOME/.local/share/go}"
GOMIRROR="${GOMIRROR:-https://dl.google.com/go}"

trap go_env_clean_env INT TERM EXIT
go_env_main "$@"
go_env_clean_env


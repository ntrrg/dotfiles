#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

main() {
  case $1 in
    -h | --help )
      show_help
      ;;

    -d | --delete )
      delete "$2"
      ;;

    -l | --list )
      ls "$GOENVS"
      ;;

    * )
      activate "$1"
      ;;
  esac
}

activate() {
  GORELEASE="${1:-$(get_latest_release)}"
  GOENV="go$GORELEASE.linux-$GOARCH"
  GOROOT="$GOENVS/$GOENV"

  if [ ! -d "$GOROOT" ]; then
    PACKAGE="$GOENV.tar.gz"
    wget -cqO "/tmp/$PACKAGE" "$GOMIRROR/$PACKAGE"
    mkdir -p "$GOROOT"
    tar -C "$GOROOT" --strip-components 1 -xpf "/tmp/$PACKAGE"
  fi

  "$GOROOT/bin/go" version > /dev/null || (
    rm -rf "$GOROOT"
    activate
    return $?
  )

  GOPATH="${GOPATH:-$HOME/go}"
  PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

  echo "export GOROOT=\"$GOROOT\""
  echo "export GOPATH=\"$GOPATH\""
  echo "export PATH=\"$PATH\""
}

delete() {
  GORELEASE="$1"
  GOENV="go$GORELEASE.linux-$GOARCH"
  GOROOT="$GOENVS/$GOENV"

  rm -r "$GOROOT"
}

get_arch() {
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
      echo "can't define Go architecture for '$(uname -m)'"
      return 1
      ;;
  esac
}

get_latest_release() {
  wget -qO - 'https://golang.org/dl/?mode=json' |
    grep -m 1 "version" |
    cut -d '"' -f 4 |
    sed "s/go//"
}

show_help() {
  cat <<EOF
$0 - manage Go environments.

Usage: \$($0 [RELEASE])
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

GOARCH="${GOARCH:-$(get_arch)}"
GOENVS="${GOENVS:-$HOME/.local/share/go}"
GOMIRROR="${GOMIRROR:-https://dl.google.com/go}"

main "$@"


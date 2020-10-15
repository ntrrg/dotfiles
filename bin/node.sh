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
      ls "$NODEJS_ENVS"
      ;;

    * )
      create "$1"
      ;;
  esac
}

create() {
  NODEJS_RELEASE="${1:-$(get_latest_release)}"
  NODEJS_ENV="node-v$NODEJS_RELEASE-linux-$NODEJS_ARCH"
  NODEJS_HOME="$NODEJS_ENVS/$NODEJS_ENV"

  if [ ! -d "$NODEJS_HOME" ]; then
    PACKAGE="$NODEJS_ENV.tar.xz"
    wget -cqO "/tmp/$PACKAGE" "$NODEJS_MIRROR/v$NODEJS_RELEASE/$PACKAGE"
    mkdir -p "$NODEJS_HOME"
    tar -C "$NODEJS_HOME" --strip-components 1 -xpf "/tmp/$PACKAGE"
  fi

  "$NODEJS_HOME/bin/node" --version > /dev/null || (
    rm -rf "$NODEJS_HOME"
    activate
    return $?
  )

  PATH="$NODEJS_HOME/bin:$PATH"

  echo "export NODEJS_HOME=$NODEJS_HOME"
  echo "export PATH=$PATH"
}

delete() {
  NODEJS_RELEASE="$1"
  NODEJS_ENV="node-v$NODEJS_RELEASE-linux-$NODEJS_ARCH"
  NODEJS_HOME="$NODEJS_ENVS/$NODEJS_ENV"

  rm -r "$NODEJS_HOME"
}

get_arch() {
  case "$(uname -m)" in
    x86_64 | amd64 )
      echo "x64"
      ;;

    armv8* | arm64 | aarch64 )
      echo "arm64"
      ;;

    armv7* )
      echo "armv7l"
      ;;

    * )
      echo "can't define Node.js architecture for '$(uname -m)'"
      return 1
      ;;
  esac
}

get_latest_release() {
  wget -qO - 'https://nodejs.org/en/download/current/' |
    grep -m 1 "Latest Current Version: " |
    cut -d '>' -f 3 |
    sed "s/<\/strong//"
}

show_help() {
  BIN_NAME="$(basename "$0")"

  cat <<EOF
$BIN_NAME - manage Node.js environments.

Usage: \$($BIN_NAME [RELEASE])
   or: $BIN_NAME -l
   or: $BIN_NAME -d RELEASE

If no release is given, the latest release will be used.

Options:
  -d, --delete=RELEASE   Remove the given release
  -h, --help             Show this help message
  -l, --list             List all the local releases

Environment variables:
  * 'NODEJS_ARCH' is the Node.js binary architecture to be used. ($NODEJS_ARCH)
  * 'NODEJS_ENVS' points to the directory that will hold the Node.js files of
    any other releases. ($NODEJS_ENVS)
  * 'NODEJS_MIRROR' is the mirror used to download the Node.js binary releases.
    ($NODEJS_MIRROR)

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

NODEJS_ARCH="${NODEJS_ARCH:-$(get_arch)}"
NODEJS_ENVS="${NODEJS_ENVS:-$HOME/.local/share/node}"
NODEJS_MIRROR="${NODEJS_MIRROR:-https://nodejs.org/dist}"

main "$@"


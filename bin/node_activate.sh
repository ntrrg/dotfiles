#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

node_env_main() {
  case $1 in
    -h | --help )
      node_env_show_help
      ;;

    -d | --delete )
      node_env_delete "$2"
      ;;

    -l | --list )
      ls "$NODEJS_ENVS"
      ;;

    * )
      node_env_create "$1"
      ;;
  esac
}

node_env_clean_env() {
  set +e
  trap - INT TERM EXIT
  unset -f node_env_clean_env
  unset -f node_env_create
  unset -f node_env_delete
  unset -f node_env_get_arch
  unset -f node_env_get_latest_release
  unset -f node_env_main
  unset -f node_env_on_trap
  unset -f node_env_show_help
}

node_env_create() {
  local NODEJS_RELEASE="${1:-$(node_env_get_latest_release)}"
  local NODEJS_ENV="node-v$NODEJS_RELEASE-linux-$NODEJS_ARCH"

  export NODEJS_HOME="$NODEJS_ENVS/$NODEJS_ENV"

  if [ ! -d "$NODEJS_HOME" ]; then
    local PACKAGE="$NODEJS_ENV.tar.xz"
    wget -cO "/tmp/$PACKAGE" "$NODEJS_MIRROR/v$NODEJS_RELEASE/$PACKAGE"
    mkdir -p "$NODEJS_HOME"
    tar -C "$NODEJS_HOME" --strip-components 1 -xpf "/tmp/$PACKAGE"
  fi

  PATH="$NODEJS_HOME/bin:$PATH"

  if [ -z "$NODEJS_MODULES" ] && [ -d "node_modules" ]; then
    export NODEJS_MODULES="$PWD/node_modules"
  fi

  if [ -n "$NODEJS_MODULES" ]; then
    PATH="$NODEJS_MODULES/.bin:$PATH"
  fi

  export PATH
}

node_env_delete() {
  local NODEJS_RELEASE="${1:-$(node_env_get_latest_release)}"
  local NODEJS_ENV="node-v$NODEJS_RELEASE-linux-$NODEJS_ARCH"
  local NODEJS_HOME="$NODEJS_ENVS/$NODEJS_ENV"

  rm -r "$NODEJS_HOME"
}

node_env_get_arch() {
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
      echo "can't define Node.js architecture for $ARCH"
      return 1
      ;;
  esac
}

node_env_get_latest_release() {
  wget -qO - 'https://nodejs.org/en/download/current/' |
    grep -m 1 "Latest Current Version: " |
    cut -d '>' -f 3 |
    sed "s/<\/strong//"
}

node_env_on_trap() {
  local ERR_CODE=$?

  node_env_clean_env

  PATH="$(
    echo "$PATH" |
    sed "s/$(echo "$NODEJS_HOME/bin:" | sed -re "s/\//\\\\\//g")//" |
    sed "s/$(echo "$NODEJS_MODULES/.bin:" | sed -re "s/\//\\\\\//g")//"
  )"

  export PATH
  return $ERR_CODE
}

node_env_show_help() {
  cat <<EOF
$0 - manage Node.js environments.

Usage: $0 [RELEASE]
   or: $0 -l
   or: $0 -d RELEASE

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
  * 'NODEJS_MODULES' is the Node.js workspace path. (./ if there is a
    node_modules directory)

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF
}

NODEJS_ARCH="${NODEJS_ARCH:-$(node_env_get_arch)}"
NODEJS_ENVS="${NODEJS_ENVS:-$HOME/.local/share/node}"
NODEJS_MIRROR="${NODEJS_MIRROR:-https://nodejs.org/dist}"

trap node_env_on_trap INT TERM EXIT
node_env_main "$@"
node_env_clean_env


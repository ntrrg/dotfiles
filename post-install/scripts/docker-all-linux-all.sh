#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

#########
# RULES #
#########
# SUPER_USER=true
# ENV=!container
# EXEC_MODE=system
# BIN_DEPS=b2sum;dpkg;wget
#########

#########
# ENV_* #
#########
# CONTAINER: if 'true', the environment is a container.
#########

set -e
trap clean EXIT

# STAGE="$1"

check() {
  return 0
}

download() {
  cd "$CACHE_DIR"

  MIRROR="https://download.docker.com/linux/debian/dists/"
  CONTAINERD_PKG="containerd.io_1.2.5-1"
  DOCKER_PKG="docker-ce_18.09.5~3-0"

  case "$OS" in
    *-9 )
      MIRROR="$MIRROR/stretch"
      DOCKER_PKG="$DOCKER_PKG~debian-stretch"
      ;;

    *-10 )
      MIRROR="$MIRROR/buster"
      DOCKER_PKG="$DOCKER_PKG~debian-buster"
      ;;

    * )
      echo "Unsupported Debian version '$OS'"
      ;;
  esac

  MIRROR="$MIRROR/pool/stable"

  case "$ARCH" in
    x86_64 )
      MIRROR="$MIRROR/amd64"
      CONTAINERD_PKG="${CONTAINERD_PKG}_amd64"
      DOCKER_PKG="${DOCKER_PKG}_amd64"
      ;;

    * )
      echo "Unsupported OS architecture '$ARCH'"
      ;;
  esac

  CONTAINERD_PKG="$CONTAINERD_PKG.deb"
  DOCKER_PKG="$DOCKER_PKG.deb"

  if [ ! -f "$CONTAINERD_PKG" ]; then
    wget "$MIRROR/$CONTAINERD_PKG"
  fi

  if [ ! -f "$DOCKER_PKG" ]; then
    wget "$MIRROR/$DOCKER_PKG"
  fi

  return 0
}

main() {
  cd "$TMP_DIR"
  return 0
}

clean() {
  ERR_CODE="$?"
  set +e
  trap - EXIT
  return "$ERR_CODE"
}

checksum() {
  FILE="$1"

  case "$FILE" in
    my-package.tar.gz )
      CHECKSUM="30f4cfacdf9024a4f4c8233842f40a6027069e81cf5529f2441b22856773abcd716ee92d2303ad3cda5eaeecac3161e5980c0eedeb4ffa077d5c15c7f356512e"
      ;;

    * )
      echo "Invalid file '$FILE'"
      return 1
      ;;
  esac

  if ! b2sum "$FILE" | grep -q "$CHECKSUM"; then
    echo "Invalid checksum for '$FILE'"
    return 1
  fi

  return 0
}

if [ $# -eq 0 ] || [ "$1" = "all" ]; then
  check
  download
  main
else
  $1
fi


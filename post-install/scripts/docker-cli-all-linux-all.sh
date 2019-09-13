#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

#########
# RULES #
#########
# SUPER_USER=false
# ENV=
# EXEC_MODE=local
# BIN_DEPS=b2sum;wget
#########

set -e
trap clean EXIT

PACKAGE="docker-ce-cli_$RELEASE"
# STAGE="$1"

check() {
  return 0
}

download() {
  cd "$CACHE_DIR"

  MIRROR="https://download.docker.com/linux"

  case "$OS" in
    debian* )
      MIRROR="$MIRROR/debian/dists"
      PACKAGE="$PACKAGE~debian"

      case "$OS" in
        *-9 )
          MIRROR="$MIRROR/stretch"
          PACKAGE="$PACKAGE-stretch"
          ;;

        *-10 )
          MIRROR="$MIRROR/buster"
          PACKAGE="$PACKAGE-buster"
          ;;

        * )
          echo "Unsupported Debian version '$OS'"
          ;;
      esac

      MIRROR="$MIRROR/pool/stable"

      case "$ARCH" in
        x86_64 )
          MIRROR="$MIRROR/amd64"
          PACKAGE="${PACKAGE}_amd64"
          ;;

        * )
          echo "Unsupported OS architecture '$ARCH'"
          ;;
      esac

      PACKAGE="$PACKAGE.deb"
      ;;

    * )
      echo "Unsupported os '$OS'"
      ;;
  esac

  if [ -f "$PACKAGE" ] && checksum "$PACKAGE"; then
    return 0
  fi

  wget "$MIRROR/$PACKAGE" || (
    ERR="$?"
    rm -f "$PACKAGE"
    return "$ERR"
  )

  checksum "$PACKAGE"
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
    docker-ce-cli_18.09.5~3-0~debian-buster_amd64.deb )
      CHECKSUM="5c3c7688f91a617d64a633d081a6a7ffb23c43292fef37819ad583c785c92c774eb5c0154adadfdce86545bf05898324c08d67c8ee92dc485b809f0215f46fd7  docker-ce-cli_18.09.5~3-0~debian-buster_amd64.deb"
      ;;

    * )
      echo "Invalid file '$FILE'"
      return 1
      ;;
  esac

  if ! b2sum "$FILE" | grep -q $CHECKSUM; then
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


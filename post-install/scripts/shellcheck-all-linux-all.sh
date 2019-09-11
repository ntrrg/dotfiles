#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

#########
# RULES #
#########
# SUPER_USER=false
# ENV=
# EXEC_MODE=local
# BIN_DEPS=wget
#########

set -e
trap clean EXIT

# STAGE="$1"
PACKAGE="shellcheck-v$RELEASE.linux.$ARCH.tar.xz"

check() {
  return 0
}

download() {
  cd "$CACHE_DIR"

  if [ ! -f "$PACKAGE" ]; then
    wget "https://storage.googleapis.com/shellcheck/$PACKAGE"
  fi

  return 0
}

main() {
  cd "$TMP_DIR"
  tar --strip-components 1 --exclude "*.txt" \
    -C "$BASEPATH/bin" -xpf "$CACHE_DIR/$PACKAGE"
  return 0
}

clean() {
  return 0
}

if [ $# -eq 0 ] || [ "$1" = "all" ]; then
  check
  download
  main
else
  $1
fi


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

# STAGE="$1"
PACKAGE="shellcheck-v$RELEASE.linux.$ARCH.tar.xz"

check() {
  return 0
}

download() {
  cd "$CACHE_DIR"

  if [ -f "$PACKAGE" ] && checksum "$PACKAGE"; then
    return 0
  fi

  wget "https://storage.googleapis.com/shellcheck/$PACKAGE" || (
    ERR="$?"
    rm -f "$PACKAGE"
    return "$ERR"
  )

  checksum "$PACKAGE"
  return 0
}

main() {
  cd "$TMP_DIR"

  # shellcheck disable=2230
  if [ "$FORCE" = "false" ] && which shellcheck; then
    if shellcheck --version | grep -q "version: $RELEASE"; then
      return 0
    fi
  fi

  tar --strip-components 1 --exclude "*.txt" \
    -C "$BASEPATH/bin" -xpf "$CACHE_DIR/$PACKAGE"
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
    shellcheck-v0.7.0.linux.x86_64.tar.xz )
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

which() {
  command -v "$1" > /dev/null
}

if [ $# -eq 0 ] || [ "$1" = "all" ]; then
  check
  download
  main
else
  $1
fi


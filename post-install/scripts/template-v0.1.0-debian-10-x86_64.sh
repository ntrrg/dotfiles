#!/bin/sh
# Copyright (c) YYYY John Doe
# Released under the MIT License

# Every script must have rules, this rules are constraints for running the
# script. They have the syntax 'KEY=VALUE'. The special rules are:
#
#   * 'SUPER_USER': determines whether the script requires super-user
#     privileges to run. Valid values are 'true' or 'false'.
#   * 'EXEC_MODE': determines whether the script may be executed in local or
#     system mode. Valid values are 'local' or 'system'.
#   * 'BIN_DEPS': is a semi-colon separated list of binaries dependencies.
#   * 'ENV': is a semi-colon separated list of environment requirements by the
#     script to be executed. An exclamation mark ('!') prefix may be used for
#     negation. For example, if 'gui' is in the list, there must be an
#     'ENV_GUI=true' environment variable, which in this case means the script
#     requires GUI support; or if '!container' is in the list, there must be an
#     'ENV_CONTAINER=false' environment variable, which in this case means the
#     script can't be executed inside a container.

#########
# RULES #
#########
# SUPER_USER=false
# EXEC_MODE=local
# BIN_DEPS=b2sum;wget
# ENV=template
#########

#########
# ENV_* #
#########
# KEY: this section is intended for explaning the used ENV_* variables.
# GUI: if 'true', the environment supports GUI.
# CONTAINER: if 'true', the environment is a container.
# HARDWARE: if 'true, the environment has access to the hardware.
#########

set -e
trap clean EXIT

STAGE="$1"

# Environment variables:
#   * 'STAGE': is the current stage.
#   * 'SU_PASSWD': contains the root password.
#   * 'CACHE_DIR': is the directory where the script should download its files.
#   * 'TMP_DIR': is the temporal filesystem directory.
#   * 'OS': is the current OS.
#   * 'ARCH': is the current OS architecture.
#   * 'RELEASE': is the package release to setup.
#   * 'EXEC_MODE': is the current execution mode.
#   * 'BASEPATH': is the installation path for packages.

# Any returned value different than 0 means failure.

check() {
  # This stage checks if the script may be executed in the current environment.
  echo "Checking..."
  return 0
}

download() {
  # This stage downloads all the needed files by the script. Any should be done
  # in CACHE_DIR.
  cd "$CACHE_DIR"
  echo "Downloading..."
  return 0
}

main() {
  # This stage executes the main code of the script.
  cd "$TMP_DIR"
  echo "Running..."
  return 0
}

clean() {
  # This stage should remove trash files or unset execution configurations.
  # This stage will be executed every time the script is executed.
  ERR_CODE="$?"
  set +e
  trap - EXIT

  # ---------------------------------------------------------------------------

  case "$STAGE" in
    check )
      echo "Cleaning after check..."
      ;;

    download | main )
      echo "Cleaning after download/main..."
      ;;

    * )
      echo "Cleaning after '$STAGE'..."
      ;;
  esac

  return "$ERR_CODE"
}

# Optional helpers

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


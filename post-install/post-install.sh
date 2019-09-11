#!/bin/sh
# Copyright (c) 2019 Miguel Angel Rivera Notararigo
# Released under the MIT License

set -e

export TMP_DIR="${TMP_DIR:-/tmp}"
export CACHE_DIR="${CACHE_DIR:-$TMP_DIR}"
export SU_PASSWD="$SU_PASSWD"

DEBUG="${DEBUG:-false}"
MODES="check download main"
MIRROR="${MIRROR:-https://post-install.nt.web.ve}"
SCRIPTS=""
SCRIPTS_DIR="${SCRIPTS_DIR:-$TMP_DIR}"
SCRIPTS_MIRROR="${SCRIPTS_MIRROR:-$MIRROR/scripts}"
TARGETS_MIRROR="${TARGETS_MIRROR:-$MIRROR/targets}"

export OS
export ARCH
export RELEASE
export EXEC_MODE
export BASEPATH

main() {
  while [ $# -gt 0 ]; do
    case $1 in
      --atomic )
        MODES="all"
        ;;

      --cache )
        CACHE_DIR="$2"
        shift
        ;;

      --debug )
        DEBUG="true"
        ;;

      --download )
        MODES="download"
        ;;

      -h | --help )
        show_help
        return
        ;;

      --mirror )
        MIRROR="$2"
        shift
        ;;

      --smirror )
        SCRIPTS_MIRROR="$2"
        shift
        ;;

      --tmirror )
        TARGETS_MIRROR="$2"
        shift
        ;;

      -P | --passwd )
        SU_PASSWD="$2"
        shift
        ;;

      --scripts )
        SCRIPTS_DIR="$2"
        shift
        ;;

      --temp )
        TMP_DIR="$2"
        shift
        ;;

      * )
        break
        ;;
    esac

    shift
  done

  mkdir -p "$SCRIPTS_DIR"

  TARGET="$1"

  if [ -z "$TARGET" ] || [ "$TARGET" = "-" ]; then
    TARGET="-"
  elif [ ! -f "$TARGET" ]; then
    echo "Can't find '$TARGET'"
    printf "Downloading from '%s'... " "$TARGETS_MIRROR"

    wget "$(debug not echo "-q")" "$TARGETS_MIRROR/$TARGET" || (
      ERR="$?"
      rm -f "$TARGET"
      echo "[FAIL]"
      return "$ERR"
    )

    echo "[DONE]"
  fi

  ERRORS="false"

  # shellcheck disable=SC2002 disable=2013
  for LINE in $(cat "$TARGET" | grep -v "^#" | grep -v "^$"); do
    if echo "$LINE" | grep -q "="; then
      NAME="$(echo "$LINE" | cut -d "=" -f 1)"
      VALUE="$(echo "$LINE" | cut -d "=" -f 2)"

      if [ "$NAME" = "BASEPATH" ] && echo "$VALUE" | grep -q "^\~"; then
        VALUE="$HOME/$(echo "$VALUE" | sed "s/^\~\///")"
      fi

      export "$NAME"="$VALUE"
    else
      SCRIPTS="$SCRIPTS $LINE"
      NAME="$LINE"
      FILE="$SCRIPTS_DIR/$LINE-$OS-$ARCH.sh"

      if [ ! -f "$FILE" ]; then
        echo "Can't find '$FILE'"
        printf "Downloading from '%s'... " "$SCRIPTS_MIRROR"

        URL="$SCRIPTS_MIRROR/$(basename "$FILE")"
        wget -"$(debug not echo "q")"O "$FILE" "$URL" || (
          ERR="$?"
          rm -f "$FILE"
          echo "[FAIL]"
          return "$ERR"
        )

        chmod +x "$FILE"
        echo "[DONE]"
      fi

      if [ "$MODES" = "download" ]; then
        continue
      fi

      echo "Checking '$NAME' rules..."

      check_su_passwd "$FILE"
      check_rules "$FILE" || ERRORS="true"
    fi
  done

  if [ "$ERRORS" = "true" ]; then
    return 1
  fi

  for MODE in $MODES; do
    echo
    echo "############################################################"
    echo
    echo "Running '$MODE' stage..."

    for SCRIPT in $SCRIPTS; do
      echo
      printf "* %s " "$SCRIPT"
      debug echo
      RE="^.\+-v\(.\+\)$"
      RELEASE="$(echo "$SCRIPT" | sed "s/$RE/\1/")"

      FILE="$SCRIPTS_DIR/$SCRIPT-$OS-$ARCH.sh"
      eval "$FILE $MODE $(debug not printf "> /dev/null")" || (
        ERR="$?"
        echo "[FAIL]"
        return "$ERR"
      )

      debug not echo "[DONE]"
    done
  done

  return 0
}

check_rules() {
  FILE="$1"
  ERRORS="false"

  # ENV

  RULES="$(grep "^# ENV=" "$FILE" | sed "s/# ENV=//" | tr ";" " ")"

  for RULE in $RULES; do
    NAME=""
    VALUE=""

    if echo "$RULE" | grep -q "^\!"; then
      VALUE="false"
    else
      VALUE="true"
    fi

    NAME="ENV_$(echo "$RULE" | tr -d "\!" | tr "[:lower:]" "[:upper:]")"

    if ! env | grep -q "^$NAME=$VALUE$"; then
      ERRORS="true"
      echo "ENV: broken rule '$RULE'"
      echo "  Want: '$NAME=$VALUE'; Got: '$(env | grep "^$NAME")'"
    fi
  done

  # EXEC_MODE

  if [ "$EXEC_MODE" = "local" ] && grep -q "^# EXEC_MODE=system" "$FILE"; then
    ERRORS="true"
    echo "EXEC_MODE: can't be executed in local mode"
  fi

  # BIN_DEPS

  BIN_DEPS="$(
    grep "^# BIN_DEPS=" "$FILE" |
    sed "s/# BIN_DEPS=//" |
    tr ";" " "
  )"

  for BIN_DEP in $BIN_DEPS; do
    if ! command -v "$BIN_DEP" > /dev/null; then
      ERRORS="true"
      echo "BIN_DEP: '$BIN_DEP' not found"
    fi
  done

  if [ "$ERRORS" = "true" ]; then
    return 1
  fi

  return 0
}

check_su_passwd() {
  if [ -n "$SU_PASSWD" ]; then
    return 0
  fi

  FILE="$1"

  if grep -q "^# SUPER_USER=false" "$FILE" &&
      grep -q "^# EXEC_MODE=local" "$FILE" &&
      [ "$EXEC_MODE" = "local" ]; then
    return 0
  fi

  trap "stty echo" EXIT
  stty -echo
  printf "%s" "Root password: "
  IFS= read -r SU_PASSWD
  stty echo
  trap - EXIT
  echo
  return 0
}

debug() {
  VALUE="true"

  if [ "$1" = "not" ]; then
    VALUE="false"
    shift
  fi

  if [ "$DEBUG" = "$VALUE" ]; then
    "$@"
  fi

  return 0
}

show_help() {
  cat <<EOF
$0 - Post installation script. It setup the environment as the given target.

Usage: $0 [OPTIONS] [TARGET]

TARGET is a file containing the list of scripts to run. If TARGET doesn't exist
it will be downloaded from the targets mirror. If no target is given, the
script list will be read from the standard input.

Options:
      --atomic          Run all stages in a single call. By default, scripts
                        are executed by stages, this means they are executed
                        three times (one per stage, excluding 'clean'), the
                        first time, the 'check' stage of every script is
                        executed, then the 'download' stage of every script and
                        finally the 'main' stage of every script.
      --cache=PATH      Set the cache directory to find/download the needed
                        files by the scripts. The user must have write
                        permissions. ($CACHE_DIR)
      --debug           Print debugging messages.
  -D, --download        Just run the download stage of every script.
      --mirror=URL      Use URL as base mirror for targets and scripts.
                        ($MIRROR)
      --smirror=URL     Use URL as scripts mirror when some script can't be
                        found locally. ($SCRIPTS_MIRROR)
      --tmirror=URL     Use URL as targets mirror when some target can't be
                        found locally. ($TARGETS_MIRROR)
  -h, --help            Show this help message.
  -P, --passwd=PASSWD   Use PASSWD as root password.
      --scripts=PATH    Use PATH as scripts directory. ($SCRIPTS_DIR)
      --temp=PATH       Use PATH as temporal filesystem. The user must have
                        write permissions. ($TMP_DIR)

Script list file syntax:
  A line-separated list of scripts to run. Each line must have one of the
  following syntax:

    KEY=VALUE     # Environment variable
    NAME-vRELEASE # Script

  See $TARGETS_MIRROR/template.slist

Scripts syntax:
  * The script must be intrepreted by 'sh'.
  * The script must have the 'check', 'download', 'main' and 'clean' stages.
  * The script may have custom functions and variables.
  * The script must pass shellcheck.

  See $SCRIPTS_MIRROR/template-v0.1.0-debian-10-x86_64.sh

Environment variables:
  * 'CACHE_DIR': behaves as the '--cache' flag.
  * 'DEBUG': behaves as the '--debug' flag.
  * 'MIRROR': behaves as the '--mirror' flag.
  * 'SCRIPTS_DIR': behaves as the '--scripts' flag.
  * 'SCRIPTS_MIRROR': behaves as the '--smirror' flag.
  * 'SU_PASSWD': behaves as the '-P, --passwd' flags.
  * 'TARGETS_MIRROR': behaves as the '--tmirror' flag.
  * 'TMP_DIR': behaves as the '--temp' flag.

Copyright (c) 2019 Miguel Angel Rivera Notararigo
Released under the MIT License
EOF

  return 0
}

main "$@"


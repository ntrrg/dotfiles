#!/bin/sh

OLD_PATH="${PATH}"
RELEASE=${1:-1.11.4}
GOENVS=${GOENVS:-${HOME}/.local/share/go}
TARGET="${GOENVS}/go${RELEASE}.linux-amd64"

clean_env() {
  unset PACKAGE RELEASE TARGET
  trap - INT TERM EXIT
}

on_error() {
  clean_env

  export PATH="$(
    echo "${PATH}" |
    sed "s/$(echo "${GOROOT}/bin:" | sed -re "s/\//\\\\\//g")//" |
    sed "s/$(echo "${GOPATH}/bin:" | sed -re "s/\//\\\\\//g")//"
  )"

  unset TARGET

  return 1
}

trap on_error INT TERM EXIT

if [ "${GOROOT}" = "${TARGET}" ]; then
  echo "Go v${RELEASE} is active"
else
  export GOROOT="${TARGET}"

  if [ ! -d "${GOROOT}" ]; then
    echo "Downloading Go v${RELEASE}.."
    echo

    PACKAGE="go${RELEASE}.linux-amd64.tar.gz"

    (cd "/tmp" && wget -c "https://dl.google.com/go/${PACKAGE}") &&
    mkdir -p "${GOENVS}" &&
    (cd "${GOENVS}" && tar -xf "/tmp/${PACKAGE}" && mv go "${GOROOT}")

    echo
    echo "Done"
  fi

  if [ -z "$GOPATH" ]; then
    export GOPATH="${HOME}/go"

    echo "By default, Go uses '~/go' as workspace, you can change this using:"
    echo "  * ln -sf /path/to/myworkspace ~/go (recommended)"
    echo "  * export GOPATH=/path/to/myworkspace"
    echo
  fi

  export PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"

  echo "Go v${RELEASE} activated"
  clean_env
fi

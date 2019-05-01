#!/bin/sh

export OLD_PATH="${PATH}"
NODE_ENVS=${NODE_ENVS:-${HOME}/.local/share/nodejs}
RELEASE=${1:-11.5.0}
TARGET="${NODE_ENVS}/node-v${RELEASE}-linux-x64"

clean_env() {
  unset PACKAGE RELEASE TARGET
  trap - INT TERM EXIT
}

on_error() {
  clean_env

  export PATH="$(
    echo "${PATH}" |
    sed "s/$(echo "${NODEJS_HOME}/bin:" | sed -re "s/\//\\\\\//g")//" |
    sed "s/$(echo "${NODEJS_MODULES}/.bin:" | sed -re "s/\//\\\\\//g")//"
  )"

  unset NODEJS_HOME NODEJS_MODULES

  return 1
}

trap on_error INT TERM EXIT

if [ "${NODEJS_HOME}" = "${TARGET}" ]; then
  echo "Node.js v${RELEASE} is active"
else
  export NODEJS_HOME="${TARGET}"

  if [ ! -d "${NODEJS_HOME}" ]; then
    echo "Downloading Node.js v${RELEASE}.."
    echo

    PACKAGE="node-v${RELEASE}-linux-x64.tar.xz"

    (cd "/tmp" && wget -c "https://nodejs.org/dist/v${RELEASE}/${PACKAGE}") &&
    mkdir -p "${NODE_ENVS}" &&
    (cd "${NODE_ENVS}" && tar -xf "/tmp/${PACKAGE}")

    echo
    echo "Done"
  fi

  export PATH="${NODEJS_HOME}/bin:${PATH}"

  if [ -d "node_modules" ]; then
    export NODEJS_MODULES="${PWD}/node_modules"
    export PATH="${NODEJS_MODULES}/.bin:${PATH}"
  fi

  echo "Node.js v${RELEASE} activated"
  clean_env
fi

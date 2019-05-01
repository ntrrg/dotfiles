#!/bin/sh

if [ -n "${NODEJS_HOME}" ]; then
  export PATH="$(
    echo "${PATH}" |
    sed "s/$(echo "${NODEJS_HOME}/bin:" | sed -re "s/\//\\\\\//g")//" |
    sed "s/$(echo "${NODEJS_MODULES}/.bin:" | sed -re "s/\//\\\\\//g")//"
  )"

  unset NODEJS_HOME NODEJS_MODULES
fi

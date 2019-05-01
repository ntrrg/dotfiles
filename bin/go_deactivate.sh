#!/bin/sh

if [ -n "${GOROOT}" ]; then
  export PATH="$(
    echo "${PATH}" |
    sed "s/$(echo "${GOROOT}/bin:" | sed -re "s/\//\\\\\//g")//" |
    sed "s/$(echo "${GOPATH}/bin:" | sed -re "s/\//\\\\\//g")//"
  )"

  unset GOROOT
fi

#!/bin/sh

set -e

for MODE in "active" "inactive"; do
  for LINK in $(find . -name "*-$MODE.svg" -type l); do
    ln -sf "border-$MODE.svg" "$LINK" 
  done
done


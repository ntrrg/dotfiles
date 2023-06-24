#!/bin/bash

set -euo pipefail

_text=""
_alt=""
_tooltip=""
_class=""
_percentage=0

printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": ["%s"], "percentage": %s }' "$_text" "$_alt" "$_tooltip" "$_class" "$_percentage"

#echo "$_text"
#echo "$_tooltip"
#echo "$_class"

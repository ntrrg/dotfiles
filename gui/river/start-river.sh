#!/bin/sh

set -eo pipefail

export TMPDIR="${TMPDIR:-"/tmp"}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-"$TMPDIR/runtime-dir-$(id -u)"}"

if [ ! -d "${XDG_RUNTIME_DIR}" ]; then
	mkdir "${XDG_RUNTIME_DIR}"
	chmod -R a=,u=rwX "${XDG_RUNTIME_DIR}"
fi

export XDG_CURRENT_DESKTOP="river"
export XDG_SESSION_DESKTOP="river"

export GDK_BACKEND="wayland"
export QT_QPA_PLATFORM="wayland"
export CLUTTER_BACKEND="wayland"
export SDL_VIDEODRIVER="wayland"
export ELM_DISPLAY="wl"
export ELM_ACCEL="opengl"
export ECORE_EVAS_ENGINE="wayland_egl"
export MOZ_ENABLE_WAYLAND="1"

exec dbus-run-session river

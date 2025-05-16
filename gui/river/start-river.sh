#!/bin/sh

set -eo pipefail

export TMPDIR="${TMPDIR:-"/tmp"}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-"$TMPDIR/runtime-dir-$(id -u)"}"

if [ ! -d "${XDG_RUNTIME_DIR}" ]; then
	mkdir "${XDG_RUNTIME_DIR}"
	chmod -R a=,u=rwX "${XDG_RUNTIME_DIR}"
fi

export GDK_BACKEND="wayland"
export QT_QPA_PLATFORM="wayland"
export CLUTTER_BACKEND="wayland"
export SDL_VIDEODRIVER="wayland"
export ELM_DISPLAY="wl"
export ELM_ACCEL="opengl"
export ECORE_EVAS_ENGINE="wayland_egl"
export MOZ_ENABLE_WAYLAND=1

export XDG_CURRENT_DESKTOP="river"
export XDG_SESSION_DESKTOP="river"

export GTK_THEME="Everforest-Green-Black"
export ICON_THEME="Everforest-Light"
export XCURSOR_THEME="phinger-cursors-light"
export XCURSOR_SIZE=24

exec dbus-run-session river "$@"

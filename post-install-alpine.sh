#!/bin/sh

set -e

BASEPATH="${BASEPATH:-/tmp}"
IS_CONTAINER="${IS_CONTAINER:-0}"
IS_GUI="${IS_GUI:-1}"
IS_HARDWARE="${IS_HARDWARE:-1}"

################
# Installation #
################

cd "$BASEPATH"

apk update
apk upgrade

apk add \
  bc \
  bzip2 \
  elinks \
  git \
  htop \
  iftop \
  dhclient \
  gzip \
  jq \
  make \
  man-pages \
  mosh \
  openssh \
  p7zip \
  pv \
  rsync \
  screen \
  sshfs \
  transmission-cli \
  unzip \
  wget \
  zsh \
  zsh-vcs

if [ "$IS_HARDWARE" -ne 0 ]; then
  apk add \
    btrfs-progs \
    cryptsetup \
    dosfstools \
    lvm2 \
    ntfs-3g \
    pciutils \
    usbutils

  if lspci | grep -q "Network controller"; then
    apk add util-linux wireless-tools wpa_supplicant
  fi

  if lsmod | grep -q "bluetooth"; then
    apk add bluez
  fi

  if [ "$IS_GUI" -ne 0 ]; then
    if lspci | grep -q "Network controller"; then
      apk add network-manager-gnome
    fi
  fi
fi

# Docker

if [ "$IS_CONTAINER" -eq 0 ]; then
  apk add docker docker-compose
fi

if [ "$IS_GUI" -ne 0 ]; then
  apk add \
    chromium \
    conky \
    evince \
    firefox \
    gimp \
    inkscape \
    telegram-desktop \
    transmission \
    vlc \
    xfce4

  if [ "$IS_HARDWARE" -ne 0 ]; then
    apk add alsa-utils xcalib
  fi

  # ST

  if [ ! -f "st-0.8.2.tar.gz" ]; then
    wget 'https://dl.suckless.org/st/st-0.8.2.tar.gz'
  fi

  if [ ! -f "st-alpha-0.8.2.diff" ]; then
    wget 'https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff'
  fi

  if [ ! -f "st-clipboard-0.8.2.diff" ]; then
    wget 'https://st.suckless.org/patches/clipboard/st-clipboard-0.8.2.diff'
  fi

  apk add fontconfig-dev freetype-dev libx11-dev libxext-dev libxft-dev \
    make musl-dev ncurses-terminfo-base
  tar -xf "st-0.8.2.tar.gz"

  (
    cd "st-0.8.2"
    find .. -name "st-*.diff" -exec git apply '{}' \+
    sed -i "s/\(pixelsize\)=[0-9]\+/\1=16/" "config.def.h"
    sed -i "s/ \(defaultbg\) = [0-9]\+/ \1 = 0/" "config.def.h"
    sed -i "s/ \(alpha\) = [0-9.]*/ \1 = 0.9/" "config.def.h"
    sed -i "s/ \(cols\) = [0-9]\+/ \1 = 85/" "config.def.h"
    sed -i "s/ \(rows\) = [0-9]\+/ \1 = 25/" "config.def.h"
    make clean install
  )

  rm -rf "st-0.8.2"

  cat <<EOF > "/usr/share/applications/simple-terminal.desktop"
[Desktop Entry]
Name=st
GenericName=Terminal
Comment=Simple terminal emulator for the X window system
Exec=st
Terminal=false
Type=Application
Encoding=UTF-8
Icon=st
Categories=System;TerminalEmulator;
Keywords=shell;prompt;command;commandline;cmd;
EOF

  # Vim

  if [ ! -f "vim-8.2.tar.bz2" ]; then
    wget 'ftp://ftp.vim.org/pub/vim/unix/vim-8.2.tar.bz2'
  fi

  apk add gcc ncurses-dev libx11-dev libxpm-dev libxt-dev libxtst-dev \
    make musl-dev

  tar -xf "vim-8.2.tar.bz2"
  (cd "vim82" && ./configure --with-features=huge && make && make install)
  rm -rf "vim82"

  cat <<EOF > "/usr/share/applications/vim.desktop"
[Desktop Entry]
Name=Vim
GenericName=Text Editor
Comment=Edit text files
Exec=st vim %F
Terminal=false
Type=Application
Encoding=UTF-8
MimeType=text/plain;
Icon=gvim
Categories=Utility;TextEditor;Development;
Keywords=Text;editor;
EOF

  # XFCE Theme

  chmod u+s "/usr/sbin/hddtemp"
  apk add materia-gtk-theme papirus-icon-theme
elif [ "$IS_GUI" -eq 0 ]; then
  # Vim

  if [ ! -f "vim-8.2.tar.bz2" ]; then
    wget 'ftp://ftp.vim.org/pub/vim/unix/vim-8.2.tar.bz2'
  fi

  apk add gcc make musl-dev ncurses-dev
  tar -xf "vim-8.2.tar.bz2"
  (cd "vim82" && "./configure" && make && make install)
  rm -rf "vim82"
fi

############
# Cleaning #
############

find "/var/cache/apk/" -mindepth 1 -delete
find "/var/log/" -mindepth 1 -delete


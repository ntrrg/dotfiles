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
  bash \
  bc \
  bzip2 \
  elinks \
  git \
  htop \
  iftop \
  dhclient \
  file \
  fuse \
  gzip \
  jq \
  make \
  mandoc \
  mosh \
  openssh \
  p7zip \
  pv \
  rsync \
  screen \
  sshfs \
  strace \
  transmission-cli \
  unzip \
  util-linux \
  wget \
  zsh \
  zsh-vcs

if [ "$IS_HARDWARE" -ne 0 ]; then
  apk add \
    btrfs-progs \
    cryptsetup \
    dmidecode \
    dosfstools \
    lvm2 \
    ntfs-3g \
    pciutils \
    smartmontools \
    usbutils

  if lspci | grep -q "Network controller"; then
    apk add wireless-tools wpa_supplicant
    rc-update add wpa_supplicant boot
  fi

  if lsmod | grep -q "bluetooth"; then
    apk add bluez
  fi
fi

# Docker

if [ "$IS_CONTAINER" -eq 0 ]; then
  apk add docker docker-compose
fi

if [ "$IS_GUI" -ne 0 ]; then
  setup-xorg-base

  if [ "$IS_HARDWARE" -ne 0 ]; then
    apk add alsa-utils xcalib xrandr
    chmod u+s "/usr/sbin/dmidecode"
    chmod u+s "/usr/sbin/smartctl"
  fi

  apk add \
    lightdm-gtk-greeter \
    xdg-user-dirs \
    xdg-utils \
    xfce4 \
    xfce4-notifyd \
    xfce4-screensaver \
    xfce4-screenshooter \
    xfce4-taskmanager

  apk add \
    xfce4-pulseaudio-plugin \
    xfce4-timer-plugin \
    xfce4-whiskermenu-plugin

  rc-update add lightdm

  apk add \
    chromium \
    conky \
    evince \
    firefox \
    flatpak \
    gimp \
    midori \
    inkscape \
    telegram-desktop \
    transmission \
    vlc

  flatpak remote-add --if-not-exists \
    flathub https://flathub.org/repo/flathub.flatpakrepo || true

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
    make musl-dev ncurses ncurses-dev
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

  apk add gcc ncurses ncurses-dev libx11-dev libxpm-dev libxt-dev libxtst-dev \
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

    # Materia

  if [ ! -f "materia-gtk-theme-v20190315.tar.gz" ]; then
    wget -O "materia-gtk-theme-v20190315.tar.gz" \
      'https://github.com/nana-4/materia-theme/archive/v20190315.tar.gz'
  fi

  tar -xf "materia-gtk-theme-v20190315.tar.gz"
  (cd "materia-theme-20190315" && "./install.sh")
  rm -rf "materia-theme-20190315"

    # Papirus

  if [ ! -f "papirus-icon-theme-v20190817.tar.gz" ]; then
    wget -O "papirus-icon-theme-v20190817.tar.gz" \
      'https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/20190817.tar.gz'
  fi

  tar -xf "papirus-icon-theme-v20190817.tar.gz"
  (
    cd "papirus-icon-theme-20190817"
    cp -rf "Papirus" "ePapirus" "Papirus-Dark" "Papirus-Light" \
      "/usr/share/icons/"
    find "/usr/share/icons/" -name "*Papirus*" \
      -exec cp "AUTHORS" "LICENSE" '{}' \;
    find "/usr/share/icons/" -name "*Papirus*" \
      -exec gtk-update-icon-cache -q '{}' \;
  )
  rm -rf "papirus-icon-theme-20190817"
elif [ "$IS_GUI" -eq 0 ]; then
  # Vim

  if [ ! -f "vim-8.2.tar.bz2" ]; then
    wget 'ftp://ftp.vim.org/pub/vim/unix/vim-8.2.tar.bz2'
  fi

  apk add gcc make musl-dev ncurses ncurses-dev
  tar -xf "vim-8.2.tar.bz2"
  (cd "vim82" && "./configure" && make && make install)
  rm -rf "vim82"
fi

############
# Cleaning #
############

find "/var/cache/apk/" -mindepth 1 -delete
find "/var/log/" -mindepth 1 -delete


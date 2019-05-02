#!/bin/sh

set -e

mkdir -p "$HOME/bin"

apt update
apt upgrade -y

apt install -y \
  elinks \
  git \
  golang \
  htop \
  jq \
  make \
  mosh \
  openssh \
  pv \
  rsync \
  screen \
  termux-api \
  vim \
  wget \
  zsh

# Go

mkdir -p "$HOME/../usr/lib/go/bin/"
ln -sf "$HOME/../usr/bin/go*" "$HOME/../usr/lib/go/bin/"

# Urchin

if [ ! -f urchin-v0.1.0-rc3 ]; then
  wget -O urchin-v0.1.0-rc3 'https://raw.githubusercontent.com/tlevine/urchin/v0.1.0-rc3/urchin'
fi

mv urchin-v0.1.0-rc3 "$HOME/bin/urchin"
chmod +x "$HOME/bin/urchin"

# Cleaning

apt autoremove -y > /dev/null


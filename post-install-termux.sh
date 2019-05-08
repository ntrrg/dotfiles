#!/bin/sh

set -e

apt update
apt upgrade -y

################
# Installation #
################

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
  unzip \
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

mkdir -p "$HOME/bin"
mv urchin-v0.1.0-rc3 "$HOME/bin/urchin"
chmod +x "$HOME/bin/urchin"

############
# Cleaning #
############

apt autoremove -y > /dev/null


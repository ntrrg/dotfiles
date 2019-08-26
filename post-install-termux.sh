#!/bin/sh

set -e

apt update
apt upgrade -y

################
# Installation #
################

apt install -y \
  bc \
  elinks \
  git \
  golang \
  htop \
  jq \
  make \
  mosh \
  openssh \
  protobuf \
  pv \
  rsync \
  screen \
  termux-api \
  unzip \
  vim \
  wget \
  zsh

# Go

mkdir -p "$PREFIX/lib/go/bin/"
ln -sf "$PREFIX/bin/go*" "$PREFIX/lib/go/bin/"

# Urchin

if [ ! -f urchin-v0.1.0-rc3 ]; then
  wget -O urchin-v0.1.0-rc3 'https://raw.githubusercontent.com/tlevine/urchin/v0.1.0-rc3/urchin'
fi

mkdir -p "$HOME/.local/bin"
mv urchin-v0.1.0-rc3 "$HOME/.local/bin/urchin"
chmod +x "$HOME/.local/bin/urchin"

############
# Cleaning #
############

apt autoremove -y > /dev/null


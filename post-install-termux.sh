#!/bin/sh

set -e

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

mkdir -p "$HOME/bin"

# ET

if [ ! -f et.sh ]; then
  wget 'https://gist.githubusercontent.com/ntrrg/1dbd052b2d8238fa07ea5779baebbedb/raw/371724030a77113a621fbb7f43b5be506f2eb18d/et.sh'
fi

mv et.sh "$HOME/bin/et"
chmod +x "$HOME/bin/et"

# Urchin

if [ ! -f urchin-v0.1.0-rc3 ]; then
  wget -O urchin-v0.1.0-rc3 'https://raw.githubusercontent.com/tlevine/urchin/v0.1.0-rc3/urchin'
fi

mv urchin-v0.1.0-rc3 "$HOME/bin/urchin"
chmod +x "$HOME/bin/urchin"


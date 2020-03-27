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

############
# Cleaning #
############

apt autoremove -y > /dev/null


#!/bin/sh

set -e

################
# Installation #
################

apt update
apt upgrade -y

apt install -y \
  bc \
  elinks \
  git \
  jq \
  make \
  man \
  mosh \
  openssh \
  pv \
  rsync \
  screen \
  termux-api \
  transmission \
  unzip \
  vim \
  wget \
  zsh

############
# Cleaning #
############

apt autoremove -y > "/dev/null"


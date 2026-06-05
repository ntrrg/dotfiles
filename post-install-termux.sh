#!/bin/sh

set -xeuo pipefail

################
# Installation #
################

apt-get install -y \
	file \
	git \
	git-lfs \
	gnupg \
	iproute2 \
	make \
	man \
	mosh \
	openssh \
	p7zip \
	rclone \
	rsync \
	screen \
	strace \
	termux-api \
	transmission \
	unzip \
	wget \
	zsh

# Apps

apt-get purge -fy vim "vim-*"

apt-get install -y \
	bc \
	elinks \
	neovim \
	nmap \
	pv

############
# Cleaning #
############

apt-get autoremove -y > "/dev/null"

#!/bin/sh

set -eu

################
# Installation #
################

apt update
apt upgrade -y

apt install -y \
	bc \
	elinks \
	file \
	git \
	gnupg \
	make \
	man \
	mosh \
	openssh \
	p7zip \
	pv \
	rclone \
	rsync \
	screen \
	strace \
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

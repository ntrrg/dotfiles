#!/bin/sh

set -eu

################
# Installation #
################

apt-get update
apt-get upgrade -y

apt-get install -y \
	bc \
	elinks \
	file \
	git \
	git-lfs \
	gnupg \
	make \
	man \
	mosh \
	nmap \
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

apt-get autoremove -y > "/dev/null"

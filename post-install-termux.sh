#!/bin/sh

set -eu

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

apt-get install -y \
	bc \
	elinks \
	nmap \
	pv \
	time \
	vim

############
# Cleaning #
############

apt-get autoremove -y > "/dev/null"

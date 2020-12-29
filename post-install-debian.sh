#!/bin/sh

set -eu

BASEPATH="${BASEPATH:-"/tmp"}"
IS_HARDWARE="${IS_HARDWARE:-1}"

################
# Installation #
################

cd "$BASEPATH"

apt-get install -y \
	apt-transport-https \
	bc \
	busybox \
	bzip2 \
	elinks \
	git \
	htop \
	iftop \
	file \
	gnupg \
	gzip \
	locales \
	make \
	man \
	mosh \
	netselect \
	p7zip-full \
	p7zip-rar \
	pv \
	rclone \
	rsync \
	screen \
	ssh \
	sshfs \
	strace \
	transmission-cli \
	unzip \
	wget \
	xz-utils \
	zsh

if [ "$IS_HARDWARE" -ne 0 ]; then
	apt-get install -y \
		btrfs-progs \
		cryptsetup \
		dmidecode \
		dosfstools \
		lvm2 \
		ntfs-3g \
		pciutils \
		smartmontools \
		usbutils \
		vbetool

	if lspci | grep -q "Network controller"; then
		apt-get install -y rfkill wireless-tools wpasupplicant
	fi

	if lsmod | grep -q "bluetooth"; then
		apt-get install -y bluez
	fi
fi

localedef -ci "en_US" -f "UTF-8" -A "/usr/share/locale/locale.alias" \
	"en_US.UTF-8"

# Vim

apt-get purge -fy "vim-*"
apt-get install -y vim

# New user

if [ -n "$NEW_USER" ]; then
	if ! id "$NEW_USER" 2> /dev/null; then
		useradd --shell "/bin/zsh" --create-home "$NEW_USER"
	fi
fi

############
# Cleaning #
############

apt-get autoremove -y > "/dev/null"
find "/var/cache/apt/" -mindepth 1 -delete
find "/var/lib/apt/lists/" -mindepth 1 -delete
find "/var/log/" -mindepth 1 -delete

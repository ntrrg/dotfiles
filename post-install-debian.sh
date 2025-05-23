#!/bin/sh

set -xeuo pipefail

BASEPATH="${BASEPATH:-"/tmp"}"

CHARSET="${CHARSET:-"UTF-8"}"
LANGUAGE="${LANGUAGE:-"en_US"}"

IS_HARDWARE="${IS_HARDWARE:-1}"
HAS_BLUETOOTH="${HAS_BLUETOOTH:-0}"
HAS_WIRELESS="${HAS_WIRELESS:-0}"

SETUP_FIREWALL="${SETUP_FIREWALL:-0}"
CLEAR_FIREWALL_RULES="${CLEAR_FIREWALL_RULES:-0}"
ALLOW_MOSH="${ALLOW_MOSH:-1}"
ALLOW_SSH="${ALLOW_SSH:-1}"

NEW_USER="${NEW_USER:-""}"

################
# Installation #
################

cd "$BASEPATH"

apt-get install -y locales

localedef -ci "$LANGUAGE" -f "$CHARSET" -A "/usr/share/locale/locale.alias" \
	"$LANGUAGE.$CHARSET"

apt-get install -y \
	apt-transport-https \
	bzip2 \
	file \
	fuse3 \
	git \
	git-lfs \
	gnupg \
	gzip \
	make \
	mosh \
	p7zip-full \
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

if [ "$IS_HARDWARE" -eq 1 ]; then
	apt-get install -y \
		btrfs-progs \
		cryptsetup \
		dmidecode \
		dosfstools \
		lvm2 \
		ntfs-3g \
		pciutils \
		smartmontools \
		testdisk \
		usbutils \
		vbetool

	if [ "$HAS_WIRELESS" -eq 1 ]; then
		apt-get install -y rfkill wireless-tools wpasupplicant
	fi

	if [ "$HAS_BLUETOOTH" -eq 1 ]; then
		apt-get install -y bluez
	fi
fi

# Apps

apt-get purge -fy "vim-*"

apt-get install -y \
	bc \
	elinks \
	htop \
	iftop \
	netselect \
	nmap \
	pv \
	time \
	vim

if [ "$IS_HARDWARE" -eq 1 ]; then
	apt-get install -y powertop
fi

############
# Firewall #
############

if [ "$SETUP_FIREWALL" -eq 1 ]; then
	apt-get install -y iptables

	CLEAR_FIREWALL_RULES="$CLEAR_FIREWALL_RULES" \
		ALLOW_MOSH="$ALLOW_MOSH" \
		ALLOW_SSH="$ALLOW_SSH" \
		./firewall.sh

	iptables-save > "/etc/iptables.up.rules"

	cat << EOF > "/etc/network/if-pre-up.d/iptables"
#!/bin/sh

/sbin/iptables-restore < /etc/iptables.up.rules
EOF

	chmod +x "/etc/network/if-pre-up.d/iptables"
	systemctl enable iptables.service
fi

############
# New user #
############

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

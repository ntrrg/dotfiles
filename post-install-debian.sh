#!/bin/sh

set -eux

ALLOW_SSH="${ALLOW_SSH:-1}"
BASEPATH="${BASEPATH:-"/tmp"}"
IS_HARDWARE="${IS_HARDWARE:-1}"
HAS_BLUETOOTH="${HAS_BLUETOOTH:-0}"
HAS_WIRELESS="${HAS_WIRELESS:-0}"
LANGUAGE="${LANGUAGE:-"en_US"}"
SETUP_FIREWALL="${SETUP_FIREWALL:-1}"

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
	fuse \
	gnupg \
	gzip \
	locales \
	make \
	man \
	mosh \
	netselect \
	nmap \
	p7zip-full \
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
		testdisk \
		usbutils \
		vbetool

	if [ "$HAS_WIRELESS" -ne 0 ]; then
		apt-get install -y rfkill wireless-tools wpasupplicant
	fi

	if [ "$HAS_BLUETOOTH" -ne 0 ]; then
		apt-get install -y bluez
	fi
fi

localedef -ci "$LANGUAGE" -f "UTF-8" -A "/usr/share/locale/locale.alias" \
	"$LANGUAGE.UTF-8"

apt-get purge -fy "vim-*"
apt-get install -y vim

############
# Firewall #
############

if [ "$IS_HARDWARE" -ne 0 ] && [ "$SETUP_FIREWALL" -ne 0 ]; then
	apt-get install -y iptables

	iptables -Z
	iptables -F
	iptables -P INPUT DROP
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
	iptables -A INPUT -p icmp -j ACCEPT

	if [ "$ALLOW_SSH" -ne 0 ]; then
		iptables -A INPUT -p tcp --dport 22 -j ACCEPT
	fi

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

#!/bin/sh

set -eux

ALLOW_MOSH="${ALLOW_MOSH:-1}"
ALLOW_SSH="${ALLOW_SSH:-1}"
BASEPATH="${BASEPATH:-"/tmp"}"
DE="${DE:-"none"}"
EXTRA_APPS="${EXTRA_APPS:-0}"
HAS_BLUETOOTH="${HAS_BLUETOOTH:-1}"
HAS_WIRELESS="${HAS_WIRELESS:-1}"
IS_GUI="${IS_GUI:-0}"
IS_HARDWARE="${IS_HARDWARE:-1}"
IS_LAPTOP="${IS_LAPTOP:-1}"
LANGUAGE="${LANGUAGE:-"en_US"}"
NEW_USER="${NEW_USER:-""}"
NEW_USER_PASSWORD="${NEW_USER_PASSWORD:-""}"
SETUP_FIREWALL="${SETUP_FIREWALL:-1}"

NTALPINE="${NTALPINE:-"/media/ntDisk/srv/baul/data/_/Software/Linux/Mirrors/ntalpine/main"}"

ntapk() {
	apk -X "$NTALPINE" --allow-untrusted --no-cache "$@"
}

################
# Installation #
################

cd "$BASEPATH"

apk add \
	bzip2 \
	file \
	fuse \
	git \
	git-lfs \
	gnupg \
	gzip \
	make \
	mosh \
	openssh \
	p7zip \
	patch \
	rclone \
	rsync \
	screen \
	sshfs \
	strace \
	transmission-cli \
	unzip \
	xz \
	zsh \
	zsh-vcs

if [ "$IS_HARDWARE" -ne 0 ]; then
	apk add \
		btrfs-progs \
		cryptsetup \
		dmidecode \
		dosfstools \
		lvm2 \
		ntfs-3g \
		pciutils \
		pm-utils \
		powertop \
		smartmontools \
		testdisk \
		usbutils \
		util-linux

	if [ "$HAS_WIRELESS" -ne 0 ]; then
		apk add wireless-tools wpa_supplicant
		rc-update add wpa_supplicant boot
	fi

	if [ "$HAS_BLUETOOTH" -ne 0 ]; then
		apk add bluez
		rc-update add bluetooth default
	fi
fi

# Apps.

apk add \
	bc \
	elinks \
	htop \
	iftop \
	nmap \
	pv

#apk add time

if [ "$IS_GUI" -eq 0 ]; then
	# Apps.

	ntapk add vim-tiny || apk add vim
else
	setup-xorg-base

	apk add \
		dbus \
		lightdm-gtk-greeter \
		xkill \
		xdg-user-dirs \
		xdg-utils \
		xhost

	if [ "$NEW_USER" != "ntrrg" ]; then
		rc-update add lightdm default
	fi

	if [ "$IS_HARDWARE" -ne 0 ]; then
		apk add \
			alsa-utils \
			pavucontrol \
			pulseaudio \
			pulseaudio-utils \
			xcalib \
			xrandr

		chmod u+s "/usr/sbin/dmidecode"
		chmod u+s "/usr/sbin/smartctl"

		if [ "$IS_LAPTOP" -ne 0 ]; then
			apk add acpi cpufreqd hdparm
			rc-update add cpufreqd default
		fi
	fi

	# Remove accessibility errors from X session error log.

	if ! grep -q "NO_AT_BRIDGE=1" "/etc/environment"; then
		echo "NO_AT_BRIDGE=1" >> "/etc/environment"
	fi

	# Fonts

	apk add \
		font-hermit-nerd \
		font-noto-all \
		font-noto-cjk \
		font-noto-emoji \
		libxft \
		terminus-font

	cat << EOF > "/etc/fonts/conf.avail/69-google-noto.conf"
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<!--
  Use 'Google Noto' as default font
-->
<fontconfig>
  <match>
    <test name="family" qual="any">
      <string>sans-serif</string>
    </test>

    <edit binding="strong" mode="prepend" name="family">
      <string>Noto Sans</string>
    </edit>
  </match>

  <match>
    <test name="family" qual="any">
      <string>serif</string>
    </test>

    <edit binding="strong" mode="prepend" name="family">
      <string>Noto Serif</string>
    </edit>
  </match>

  <match>
    <test name="family" qual="any">
      <string>sans</string>
    </test>

    <edit binding="strong" mode="prepend" name="family">
      <string>Noto Sans</string>
    </edit>
  </match>

	<!-- MS fonts -->

	<match>
		<test name="family">
			<string>Arial</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Noto Sans</string>
		</edit>
	</match>

	<match>
		<test name="family">
			<string>Comic Sans MS</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Noto Sans</string>
		</edit>
	</match>

	<match>
		<test name="family">
			<string>Helvetica</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Noto Sans</string>
		</edit>
	</match>

	<match>
		<test name="family">
			<string>Tahoma</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Noto Sans</string>
		</edit>
	</match>

	<match>
		<test name="family">
			<string>Times</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Noto Serif</string>
		</edit>
	</match>

	<match>
		<test name="family">
			<string>Times New Roman</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Noto Serif</string>
		</edit>
	</match>

	<match>
		<test name="family">
			<string>Verdana</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Noto Sans</string>
		</edit>
	</match>

	<!-- Monospace fonts -->

  <match>
    <test name="family" qual="any">
      <string>monospace</string>
    </test>
  
    <edit binding="strong" mode="prepend" name="family">
      <string>Noto Sans Mono</string>
    </edit>
  </match>

		<!-- MS fonts -->

	<match>
		<test name="family">
			<string>Courier New</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Noto Sans Mono</string>
		</edit>
	</match>
</fontconfig>
EOF

	ln -sf "/etc/fonts/conf.avail/69-google-noto.conf" "/etc/fonts/conf.d/69-google-noto.conf"

	cat << EOF > "/etc/fonts/conf.avail/69-hurmit-nerd-font.conf"
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<!--
  Use 'Hurmit Nerd Font' as default monospace font
-->
<fontconfig>
  <match>
    <test name="family" qual="any">
      <string>monospace</string>
    </test>

    <edit binding="strong" mode="prepend" name="family">
      <string>Hurmit Nerd Font</string>
    </edit>
  </match>

	<!-- MS fonts -->

	<match>
		<test name="family">
			<string>Courier New</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Hurmit Nerd Font</string>
		</edit>
	</match>
</fontconfig>
EOF

	ln -sf "/etc/fonts/conf.avail/69-hurmit-nerd-font.conf" "/etc/fonts/conf.d/69-hurmit-nerd-font.conf"
	fc-cache -f

	# Apps

	apk add \
		chromium \
		evince \
		ffmpeg \
		ffmpeg-libs \
		firefox \
		gimp \
		inkscape \
		telegram-desktop \
		transmission \
		vlc-qt \
		xarchiver

	if [ "$NEW_USER" = "ntrrg" ]; then
		apk add \
			alacritty

		ntapk add \
			conky \
			st \
			sxiv \
			vim-huge
	fi

	if [ "$EXTRA_APPS" -ne 0 ]; then
		apk add \
			blender \
			flatpak \
			libreoffice \
			obs-studio \
			scribus \
			tenacity

		#apk add manuskript

		flatpak remote-add --if-not-exists \
			flathub 'https://flathub.org/repo/flathub.flatpakrepo' || true

		if [ "$LANGUAGE" != "C" ]; then
			_LANG="${LANGUAGE%_*}"
			apk add "libreoffice-lang-$_LANG" || true

			_LANG="$(echo "$LANGUAGE" | tr '[:upper:]' '[:lower:]')"
			apk add "libreoffice-lang-$_LANG" || true
		fi
	fi

	if [ "$IS_HARDWARE" -ne 0 ]; then
		apk add \
			cheese \
			cups \
			cups-filters \
			scrcpy \
			simple-scan

		rc-update add cupsd default
	fi

	# Desktop Environtment

	case $DE in
	none) ;;

	# DWM
	dwm)
		# https://github.com/bakkeby/dwm-flexipatch

		apk add \
			dunst \
			dmenu \
			dwm \
			picom \
			slock \
			spacefm

		ntapk add \
			qt5ct \
			xsettingsd

		cat << EOF > "/usr/share/xsessions/dwm.desktop"
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Name=dwm
Comment=Dynamic Window Manager
Exec=dbus-launch dwm
Icon=dwm
Type=XSession
EOF
		;;

	# XFCE 4
	xfce)
		apk add \
			thunar \
			thunar-archive-plugin \
			xfce4 \
			xfce4-notifyd \
			xfce4-screensaver \
			xfce4-screenshooter

		if [ "$NEW_USER" != "ntrrg" ]; then
			apk add \
				mousepad \
				ristretto \
				xfce4-taskmanager \
				xfce4-terminal
		fi

		apk add consolekit2 xfce-polkit || apk fix

		if [ "$IS_HARDWARE" -ne 0 ]; then
			apk add xfburn

			if [ "$NEW_USER" != "ntrrg" ]; then
				apk add \
					gnome-disk-utility \
					network-manager-applet

				cat << EOF > "/etc/NetworkManager/NetworkManager.conf"
[main]
dhcp=internal

[ifupdown]
managed=true
EOF

				rc-update add networkmanager default

				if [ "$HAS_WIRELESS" -ne 0 ]; then
					apk add iwd

					cat << EOF >> "/etc/NetworkManager/NetworkManager.conf"

[device]
wifi.backend=iwd
EOF

					rc-update add iwd default
				fi

				# Thunar - Device detection

				apk add \
					gvfs \
					gvfs-afc \
					gvfs-afp \
					gvfs-archive \
					gvfs-avahi \
					gvfs-cdda \
					gvfs-dav \
					gvfs-fuse \
					gvfs-gphoto2 \
					gvfs-mtp \
					gvfs-nfs \
					gvfs-smb \
					thunar-volman

				rc-update add fuse default
			fi
		fi

		# Plugins

		apk add \
			xfce4-clipman-plugin \
			xfce4-whiskermenu-plugin \
			xfce4-xkb-plugin

		ntapk add \
			xfce4-diskperf-plugin \
			xfce4-docklike-plugin \
			xfce4-genmon-plugin \
			xfce4-netload-plugin \
			xfce4-pulseaudio-plugin \
			xfce4-sensors-plugin \
			xfce4-systemload-plugin \
			xfce4-timer-plugin
		;;
	esac

	# Themes

	apk add \
		papirus-icon-theme

	ntapk add \
		materia-gtk-theme \
		materia-gtk-theme-compact \
		materia-gtk-theme-dark \
		materia-gtk-theme-dark-compact \
		materia-gtk-theme-light \
		materia-gtk-theme-light-compact
fi

############
# Firewall #
############

if [ "$IS_HARDWARE" -ne 0 ] && [ "$SETUP_FIREWALL" -ne 0 ]; then
	apk add iptables

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

		if [ "$ALLOW_MOSH" -ne 0 ]; then
			iptables -A INPUT -p udp --dport 60000:61000 -j ACCEPT
		fi
	fi

	rc-service iptables save
	rc-update add iptables default
fi

############
# New user #
############

if [ -n "$NEW_USER" ]; then
	if ! id "$NEW_USER" 2> /dev/null; then
		adduser -s "/bin/zsh" -D "$NEW_USER"
	fi

	if [ -n "$NEW_USER_PASSWORD" ]; then
		echo "$NEW_USER:$NEW_USER_PASSWORD" | chpasswd
	fi

	_GROUPS="
		audio cdrom cdrw dialout disk floppy games input lp lpadmin netdev optical
		plugdev power rfkill scanner storage usb users video wheel
	"

	for _GROUP in $_GROUPS; do
		addgroup "$_GROUP" 2> /dev/null || true
		addgroup "$NEW_USER" "$_GROUP" 2> /dev/null || true
	done

	if [ ! -f "/home/$NEW_USER/.profile" ]; then
		cat << EOF > "/home/$NEW_USER/.profile"
export CHARSET="UTF-8"
export LANGUAGE="$LANGUAGE"
export LC_ALL="$LANGUAGE.UTF-8"
export LANG="$LANGUAGE.UTF-8"
EOF

		chown "$NEW_USER:$NEW_USER" "/home/$NEW_USER/.profile"
	fi
fi

############
# Cleaning #
############

find "/var/cache/apk/" -mindepth 1 -delete
find "/var/log/" -mindepth 1 -delete

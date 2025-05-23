#!/bin/sh

set -xeuo pipefail

BASEPATH="${BASEPATH:-"/tmp"}"

CHARSET="${CHARSET:-"UTF-8"}"
LANGUAGE="${LANGUAGE:-"en_US"}"

IS_HARDWARE="${IS_HARDWARE:-1}"
IS_LAPTOP="${IS_LAPTOP:-1}"
HAS_BLUETOOTH="${HAS_BLUETOOTH:-1}"
HAS_WIRELESS="${HAS_WIRELESS:-1}"

IS_GUI="${IS_GUI:-0}"
DE="${DE:-"none"}"
EXTRA_APPS="${EXTRA_APPS:-0}"

SETUP_FIREWALL="${SETUP_FIREWALL:-0}"
CLEAR_FIREWALL_RULES="${CLEAR_FIREWALL_RULES:-0}"
ALLOW_MOSH="${ALLOW_MOSH:-1}"
ALLOW_SSH="${ALLOW_SSH:-1}"

NEW_USER="${NEW_USER:-""}"
NEW_USER_PASSWORD="${NEW_USER_PASSWORD:-""}"

NTALPINE="${NTALPINE:-"/media/ntDisk/Baul/Software/Linux/Mirrors/ntalpine/edge/main"}"

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
	wireguard-tools \
	xz \
	zsh \
	zsh-vcs

if [ "$IS_HARDWARE" -eq 1 ]; then
	apk add \
		acpi \
		btrfs-progs \
		cpufreqd \
		cryptsetup \
		dmidecode \
		dosfstools \
		dvd+rw-tools \
		hdparm \
		keyd \
		lvm2 \
		ntfs-3g \
		pciutils \
		pm-utils \
		smartmontools \
		testdisk \
		tlp \
		usbutils \
		util-linux

	if ! grep -q "^uinput$" "/etc/modules"; then
		echo 'uinput' >> "/etc/modules"
	fi

	#rc-update add keyd default

	if [ "$IS_LAPTOP" -eq 1 ]; then
		rc-update add tlp default
		rc-update add cpufreqd default
	fi

	if [ "$HAS_WIRELESS" -eq 1 ]; then
		apk add wireless-tools wpa_supplicant
		#rc-update add wpa_supplicant boot
	fi

	if [ "$HAS_BLUETOOTH" -eq 1 ]; then
		apk add bluez
		#rc-update add bluetooth default
	fi
fi

# Applications.

apk add \
	bc \
	elinks \
	htop \
	iftop \
	nmap \
	pv

#apk add time

if [ "$NEW_USER" = "ntrrg" ]; then
	apk del vim
	ntapk add vim || apk add vim
fi

if [ "$IS_HARDWARE" -eq 1 ]; then
	apk add powertop
fi

if [ "$IS_GUI" -eq 0 ]; then
	true
else
	# Fonts

	apk add \
		font-hermit-nerd \
		font-noto-all \
		font-noto-cjk \
		font-noto-emoji \
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

	# Desktop Environtment.

	_setup_xorg() {
		apk add xorg-server

		apk add \
			libxft \
			xcalib \
			xev \
			xf86-input-libinput \
			xhost \
			xkill \
			xrandr

		# Remove accessibility errors from X session error log.
		if ! grep -q "NO_AT_BRIDGE=1" "/etc/environment"; then
			echo "NO_AT_BRIDGE=1" >> "/etc/environment"
		fi
	}

	_setup_wayland() {
		apk add \
			seatd \
			wdisplays \
			wev \
			wl-clipboard \
			wlr-randr \
			wlrctl \
			xdg-desktop-portal \
			xwayland
	}

	apk add \
		dbus \
		eudev \
		xdg-user-dirs \
		xdg-utils

	setup-devd udev

	if [ "$IS_HARDWARE" -eq 1 ]; then
		chmod u+s "/usr/sbin/dmidecode"
		chmod u+s "/usr/sbin/smartctl"
	fi

	case $DE in
	# DWM.
	dwm)
		# https://github.com/bakkeby/dwm-flexipatch

		_setup_xorg

		apk add \
			alsa-utils \
			pavucontrol \
			pulseaudio \
			pulseaudio-utils

		apk add \
			dwm \
			dunst \
			dmenu \
			pcmanfm \
			picom \
			slock

		#ntapk add \
		#	qt5ct \
		#	xsettingsd

		cat << EOF > "/usr/share/xsessions/dwm.desktop"
[Desktop Entry]
Version=1.0
Type=XSession
Name[en]=dwm
Name=dwm
Comment[en]=Dynamic Window Manager
Comment=Dynamic Window Manager
Icon=dwm
Exec=dbus-run-session dwm
X-DesktopNames=dwm
Keywords=launch;dwm;desktop;session;
EOF
		;;

	# River.
	river)
		_setup_xorg
		_setup_wayland

		apk add \
			pavucontrol \
			pipewire \
			pipewire-alsa \
			pipewire-pulse \
			wireplumber

		apk add \
			river \
			rofi-wayland \
			dunst \
			grim \
			slurp \
			swappy \
			swaybg \
			swayidle \
			swaylock \
			thunar \
			tumbler \
			waybar \
			wf-recorder \
			xdg-desktop-portal-wlr

		#ntapk add qt5ct

		mkdir -p "/usr/share/wayland-sessions"

		cat << EOF > "/usr/share/wayland-sessions/river.desktop"
[Desktop Entry]
Version=1.0
Type=Application
Name[en]=River
Name=River
Comment[en]=This session logs in you into River
Comment=This session logs you into River
Icon=riverwm
Exec=dbus-run-session river
X-DesktopNames=River
Keywords=launch;River;desktop;session;
EOF
		;;

	# XFCE 4.
	xfce)
		_setup_xorg

		apk add lightdm-gtk-greeter
		#rc-update add lightdm default

		apk add \
			alsa-utils \
			pavucontrol \
			pulseaudio \
			pulseaudio-utils

		apk add \
			xfce4 \
			thunar \
			thunar-archive-plugin \
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

		if [ "$IS_HARDWARE" -eq 1 ]; then
			apk add xfburn

			if [ "$NEW_USER" != "ntrrg" ]; then
				apk add \
					gnome-disk-utility

				# NetworkManager.

				apk add \
					network-manager-applet \
					networkmanager-adsl \
					networkmanager-l2tp \
					networkmanager-openvpn \
					networkmanager-ovs \
					networkmanager-ppp \
					networkmanager-wwan

				cat << EOF > "/etc/NetworkManager/NetworkManager.conf"
[main]
dhcp=internal

[ifupdown]
managed=true
EOF

				rc-update add networkmanager default

				if [ "$HAS_WIRELESS" -eq 1 ]; then
					apk add iwd networkmanager-wifi

					cat << EOF >> "/etc/NetworkManager/NetworkManager.conf"

[device]
wifi.backend=iwd
EOF

					rc-update add iwd default
				fi

				if [ "$HAS_BLUETOOTH" -eq 1 ]; then
					apk add networkmanager-bluetooth
				fi

				# Thunar - Device detection.

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

		# Plugins.

		apk add \
			xfce4-clipman-plugin \
			xfce4-diskperf-plugin \
			xfce4-docklike-plugin \
			xfce4-genmon-plugin \
			xfce4-netload-plugin \
			xfce4-pulseaudio-plugin \
			xfce4-sensors-plugin \
			xfce4-systemload-plugin \
			xfce4-timer-plugin \
			xfce4-whiskermenu-plugin \
			xfce4-xkb-plugin
		;;
	esac

	# Applications.

	apk add \
		ffmpeg \
		ffmpeg-libs \
		chromium \
		flatpak \
		imagemagick \
		libsixel-tools \
		telegram-desktop \
		transmission \
		vlc-qt \
		xarchiver \
		zbar

	flatpak remote-add --if-not-exists \
		flathub 'https://flathub.org/repo/flathub.flatpakrepo' || true

	if [ "$NEW_USER" = "ntrrg" ]; then
		apk add \
			ghostty \
			mupdf \
			nsxiv

		#ntapk add conky
		#ntapk add st || apk add st
	fi

	if [ "$EXTRA_APPS" -eq 1 ]; then
		apk add \
			blender \
			evince \
			gimp \
			inkscape \
			kdenlive \
			krita \
			libreoffice \
			obs-studio \
			scribus \
			tenacity \
			waydroid

		#apk add manuskript

		if [ "$LANGUAGE" != "C" ]; then
			_LANG="${LANGUAGE%_*}"
			apk add "libreoffice-lang-$_LANG" || true

			_LANG="$(echo "$LANGUAGE" | tr '[:upper:]' '[:lower:]')"
			apk add "libreoffice-lang-$_LANG" || true
		fi
	fi

	if [ "$IS_HARDWARE" -eq 1 ]; then
		apk add \
			cheese \
			cups \
			cups-filters \
			scrcpy \
			simple-scan

		#rc-update add cupsd default
	fi

	# Themes.

	apk add adwaita-icon-theme appstream-compose gtk-murrine-engine ostree

	#if [ -n "$NEW_USER" ]; then
	#	(
	#		if ! git branch -l | grep -q "home"; then
	#			git fetch --depth 1 origin home
	#			git branch home FETCH_HEAD
	#		fi

	#		git archive --format tar home | tar -C "/home/$NEW_USER" -x
	#	) || true
	#fi

	#ntapk add \
	#	everforest-gtk-theme-green-black \
	#	everforest-icon-theme \
	#	phinger-cursor-theme || true
fi

############
# Firewall #
############

if [ "$SETUP_FIREWALL" -eq 1 ]; then
	apk add iptables

	CLEAR_FIREWALL_RULES="$CLEAR_FIREWALL_RULES" \
		ALLOW_MOSH="$ALLOW_MOSH" \
		ALLOW_SSH="$ALLOW_SSH" \
		./firewall.sh

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
		audio disk floppy input keyd kvm netdev optical plugdev power rfkill
		storage usb users video wheel
	"

	if [ "$IS_GUI" -eq 1 ]; then
		_GROUPS="$_GROUPS games lp lpadmin scanner seat"
	fi

	for _GROUP in $_GROUPS; do
		addgroup "$_GROUP" 2> /dev/null || true
		addgroup "$NEW_USER" "$_GROUP" 2> /dev/null || true
	done

	if [ ! -f "/home/$NEW_USER/.profile" ]; then
		cat << EOF > "/home/$NEW_USER/.profile"
export CHARSET="$CHARSET"
export LANGUAGE="$LANGUAGE"
export LC_ALL="$LANGUAGE.$CHARSET"
export LC_ADDRESS="$LANGUAGE.$CHARSET"
export LC_COLLATE="$LANGUAGE.$CHARSET"
export LC_CTYPE="$LANGUAGE.$CHARSET"
export LC_IDENTIFICATION="$LANGUAGE.$CHARSET"
export LC_MEASUREMENT="$LANGUAGE.$CHARSET"
export LC_MESSAGES="$LANGUAGE.$CHARSET"
export LC_MONETARY="$LANGUAGE.$CHARSET"
export LC_NAME="$LANGUAGE.$CHARSET"
export LC_NUMERIC="$LANGUAGE.$CHARSET"
export LC_PAPER="$LANGUAGE.$CHARSET"
export LC_TELEPHONE="$LANGUAGE.$CHARSET"
export LC_TIME="$LANGUAGE.$CHARSET"
export LANG="$LANGUAGE.$CHARSET"

export XDG_LOCAL_HOME="\$HOME/.local"
export XDG_BIN_HOME="\$XDG_LOCAL_HOME/bin"
export XDG_CONFIG_HOME="\$XDG_LOCAL_HOME/etc"
export XDG_DATA_HOME="\$XDG_LOCAL_HOME/share"
export XDG_STATE_HOME="\$XDG_LOCAL_HOME/var"
export XDG_CACHE_HOME="\$XDG_STATE_HOME/cache"
export PATH="\$HOME/bin:\$XDG_BIN_HOME:\$PATH"
EOF

		chown "$NEW_USER:$NEW_USER" "/home/$NEW_USER/.profile"
	fi
fi

############
# Cleaning #
############

find "/var/cache/apk/" -mindepth 1 -delete
find "/var/log/" -mindepth 1 -delete

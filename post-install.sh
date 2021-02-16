#!/bin/sh

set -eu

BASEPATH="${BASEPATH:-"/tmp"}"
DE="${DE:-"xfce"}"
IS_GUI="${IS_GUI:-1}"
IS_HARDWARE="${IS_HARDWARE:-1}"
IS_LAPTOP="${IS_LAPTOP:-1}"
LANGUAGE="${LANGUAGE:-"C"}"
NEW_USER="${NEW_USER:-""}"
SETUP_FIREWALL="${SETUP_FIREWALL:-0}"

################
# Installation #
################

cd "$BASEPATH"

apk add \
	bc \
	bzip2 \
	elinks \
	git \
	htop \
	iftop \
	file \
	fuse \
	gnupg \
	gzip \
	make \
	man-pages \
	mandoc \
	mosh \
	openssh \
	p7zip \
	pv \
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
		smartmontools \
		usbutils \
		util-linux

	if lspci | grep -q "Network controller"; then
		apk add wireless-tools wpa_supplicant
		rc-update add wpa_supplicant boot
	fi

	if lsmod | grep -q "bluetooth"; then
		apk add bluez
		rc-update add bluetooth default
	fi
fi

if [ "$IS_GUI" -eq 0 ]; then
	apk add vim
else
	setup-xorg-base

	apk add \
		xkill \
		xdg-user-dirs \
		xdg-utils \
		xhost

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

	# Desktop Environtment

	apk add \
		dbus \
		lightdm-gtk-greeter

	case $DE in
	# DWM
	dwm)
		apk add \
			dunst \
			dmenu \
			dwm \
			picom \
			slock \
			spacefm

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
	xfce | xfce-full)
		apk add \
			consolekit2 \
			xfce-polkit \
			xfce4 \
			xfce4-notifyd \
			xfce4-screensaver \
			xfce4-screenshooter || apk fix

		if ! grep -q "NO_AT_BRIDGE=1" "/etc/environment"; then
			echo "NO_AT_BRIDGE=1" >> "/etc/environment"
		fi

		# Plugins

		apk add \
			xfce4-genmon-plugin@ntrrg \
			xfce4-netload-plugin@ntrrg \
			xfce4-systemload-plugin@ntrrg \
			xfce4-timer-plugin@ntrrg

		if [ "$IS_HARDWARE" -ne 0 ]; then
			apk add \
				xfce4-diskperf-plugin@ntrrg \
				xfce4-pulseaudio-plugin@ntrrg \
				xfce4-sensors-plugin@ntrrg
		fi

		if [ "$DE" = "xfce-full" ]; then
			rc-update add lightdm default

			apk add \
				mousepad \
				ristretto \
				thunar \
				thunar-archive-plugin \
				xfce4-taskmanager \
				xfce4-terminal

			if [ "$IS_HARDWARE" -ne 0 ]; then
				apk add \
					gnome-disk-utility \
					network-manager-applet \
					xfburn

				cat << EOF > "/etc/NetworkManager/NetworkManager.conf"
[main]
dhcp=internal

[ifupdown]
managed=true
EOF

				rc-update add networkmanager default

				if lspci | grep -q "Network controller"; then
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

			# Plugins

			apk add xfce4-whiskermenu-plugin
		fi
		;;
	esac

	# Apps

	apk add \
		chromium \
		evince \
		firefox \
		flatpak \
		gimp \
		inkscape \
		midori \
		telegram-desktop \
		transmission \
		vlc-qt \
		xarchiver

	flatpak remote-add --if-not-exists \
		flathub https://flathub.org/repo/flathub.flatpakrepo || true

	if [ "$NEW_USER" = "ntrrg" ]; then
		apk add \
			conky@ntrrg \
			st@ntrrg \
			sxiv@ntrrg \
			vim@ntrrg
	fi

	# Themes

	apk add \
		materia-gtk-theme@ntrrg \
		materia-gtk-theme-compact@ntrrg \
		materia-gtk-theme-dark@ntrrg \
		materia-gtk-theme-dark-compact@ntrrg \
		materia-gtk-theme-light@ntrrg \
		materia-gtk-theme-light-compact@ntrrg \
		papirus-icon-theme
fi

############
# Firewall #
############

if [ "$SETUP_FIREWALL" -ne 0 ]; then
	iptables -Z
	iptables -F
	iptables -P INPUT REJECT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
	iptables -A INPUT -p icmp -j ACCEPT

	rc-service iptables save
	rc-update add iptables default
fi

############
# New user #
############

if [ -n "$NEW_USER" ]; then
	echo "Setting up user '$NEW_USER'.."

	if ! id "$NEW_USER" 2> /dev/null; then
		adduser -s "/bin/zsh" -D "$NEW_USER"
	fi

	if [ "$IS_GUI" -ne 0 ]; then
		case $DE in
		xfce-full)
			GROUPS="
				audio cdrom cdrw dialout disk floppy games lp netdev optical plugdev
				power rfkill scanner storage usb users video wheel
			"

			for GROUP in $GROUPS; do
				addgroup "$GROUP" 2> /dev/null || true
				addgroup "$NEW_USER" "$GROUP" 2> /dev/null || true
			done

			if [ ! -f "/home/$NEW_USER/.profile" ]; then
				cat << EOF > "/home/$NEW_USER/.profile"
export CHARSET="UTF-8"
export LANGUAGE="$LANGUAGE"
export LC_ALL="$LANGUAGE.UTF-8"
export LANG="$LANGUAGE.UTF-8"
EOF
			fi
			;;
		esac
	fi
fi

############
# Cleaning #
############

find "/var/cache/apk/" -mindepth 1 -delete
find "/var/log/" -mindepth 1 -delete

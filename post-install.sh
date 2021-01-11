#!/bin/sh

set -eu

BASEPATH="${BASEPATH:-"/tmp"}"
DE="${DE:-"xfce"}"
IS_GUI="${IS_GUI:-1}"
IS_HARDWARE="${IS_HARDWARE:-1}"
IS_LAPTOP="${IS_LAPTOP:-1}"
NEW_USER="${NEW_USER:-""}"

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
		smartmontools \
		usbutils \
		util-linux

	if lspci | grep -q "Network controller"; then
		apk add wireless-tools wpa_supplicant
		rc-update add wpa_supplicant boot
	fi

	if lsmod | grep -q "bluetooth"; then
		apk add bluez
	fi
fi

if [ "$IS_GUI" -eq 0 ]; then
	apk add vim

	# New user

	if [ -n "$NEW_USER" ]; then
		if ! id "$NEW_USER" 2> /dev/null; then
			adduser -s "/bin/zsh" -D "$NEW_USER"
		fi
	fi
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
			pm-utils \
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
			<string>Helvetica</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Noto Sans</string>
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
			<string>Comic Sans MS</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Noto Sans</string>
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
			<string>Times</string>
		</test>

		<edit name="family" mode="assign" binding="strong">
			<string>Noto Serif</string>
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

	if grep -q "@ntrrg" /etc/apk/repositories; then
		apk add \
			conky@ntrrg \
			st@ntrrg \
			sxiv@ntrrg \
			vim@ntrrg
	else
		apk add \
			conky \
			st \
			sxiv \
			vim
	fi

	# Materia

	apk add \
		materia materia-gtk3 \
		materia-dark materia-dark-gtk3

	# Papirus

	apk add papirus-icon-theme

	# Desktop Environtment

	case $DE in
	# DWM
	dwm)
		apk add \
			dunst \
			dmenu \
			dwm \
			pcmanfm \
			picom \
			slock
		;;

	# XFCE 4
	xfce | xfce-full)
		apk add lightdm-gtk-greeter
		rc-update add lightdm default

		apk add \
			dbus \
			thunar-archive-plugin \
			xfce4 \
			xfce4-notifyd \
			xfce4-screensaver \
			xfce4-screenshooter \
			xfce4-taskmanager \
			xfce4-timer-plugin

		if ! grep -q "NO_AT_BRIDGE=1" "/etc/environment"; then
			echo "NO_AT_BRIDGE=1" >> "/etc/environment"
		fi

		rc-update add dbus default

		if [ "$IS_HARDWARE" -ne 0 ]; then
			apk add xfce4-pulseaudio-plugin
		fi

		if [ "$DE" = "xfce-full" ]; then
			apk add \
				consolekit2 \
				mousepad \
				polkit \
				xfce-polkit \
				xfce4-terminal \
				xfce4-whiskermenu-plugin

			rc-update add polkit default

			if [ "$IS_HARDWARE" -ne 0 ]; then
				# Thunar - Device detection

				apk add \
					gnome-disk-utility \
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

			# Language packages

			echo "Installing language packages.."

			ALL_PKGS="$(apk search "*")"
			LANG_PKGS=""

			for PKG in $(apk info); do
				PKG_LANG="$PKG-lang"

				if echo "$ALL_PKGS" | grep -q "^$PKG_LANG-\d"; then
					LANG_PKGS="$LANG_PKGS $PKG_LANG"
				fi
			done

			apk add $LANG_PKGS
		fi
		;;
	esac

	# New user

	if [ -n "$NEW_USER" ]; then
		if ! id "$NEW_USER" 2> /dev/null; then
			adduser -s "/bin/zsh" -D "$NEW_USER"
		fi

		for GROUP in audio cdrom cdrw dialout disk floppy games lp netdev optical power rfkill scanner storage usb users video; do
			addgroup "$NEW_USER" "$GROUP" || true
		done
	fi
fi

############
# Cleaning #
############

find "/var/cache/apk/" -mindepth 1 -delete
find "/var/log/" -mindepth 1 -delete

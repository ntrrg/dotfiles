#!/bin/sh

set -e

BASEPATH="${BASEPATH:-/tmp}"
CONTAINER=${CONTAINER:-0}
GUI_ENABLED="${GUI_ENABLED:-1}"
HARDWARE=${HARDWARE:-1}

cd "$BASEPATH"

apt-get update
apt-get upgrade -y

################
# Installation #
################

apt-get install -y \
  apt-transport-https \
  elinks \
  git \
  htop \
  iftop \
  isc-dhcp-client \
  jq \
  lbzip2 \
  locales \
  make \
  mosh \
  netselect \
  p7zip-full \
  p7zip-rar \
  pv \
  rsync \
  screen \
  ssh \
  sshfs \
  transmission-cli \
  unzip \
  wget \
  zsh

if [ $HARDWARE -ne 0 ]; then
  apt-get install -y \
    btrfs-progs \
    cryptsetup \
    dosfstools \
    lvm2 \
    ntfs-3g \
    pciutils \
    usbutils \
    vbetool

  if lspci | grep -q "Network controller"; then
    apt-get install -y rfkill wireless-tools wpasupplicant
  fi

  if [ $GUI_ENABLED -eq 0 ]; then
    if lspci | grep -q "Network controller"; then
      apt-get install -y wicd-curses
    fi
  else
    if lspci | grep -q "Network controller"; then
      apt-get install -y wicd-gtk
    fi

    if lsmod | grep -q "bluetooth"; then
      apt-get install -y blueman
    fi
  fi
fi

localedef -ci en_US -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Docker

if [ $CONTAINER -eq 0 ]; then
  if [ ! -f containerd.io_1.2.5-1_amd64.deb ]; then
    wget 'https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/containerd.io_1.2.5-1_amd64.deb'
  fi

  if [ ! -f docker-ce-cli_18.09.5~3-0~debian-buster_amd64.deb ]; then
    wget 'https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/docker-ce-cli_18.09.5~3-0~debian-buster_amd64.deb'
  fi

  if [ ! -f docker-ce_18.09.5~3-0~debian-buster_amd64.deb ]; then
    wget 'https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/docker-ce_18.09.5~3-0~debian-buster_amd64.deb'
  fi

  dpkg -i \
    containerd.io_1.2.5-1_amd64.deb \
    docker-ce-cli_18.09.5~3-0~debian-buster_amd64.deb \
    docker-ce_18.09.5~3-0~debian-buster_amd64.deb ||
  apt-get install -fy

  update-rc.d docker remove
  systemctl disable containerd.service
  systemctl disable docker.service
fi

# Docker Compose

if [ $CONTAINER -eq 0 ]; then
  if [ ! -f docker-compose-1.24.0-Linux-x86_64 ]; then
    wget -O docker-compose-1.24.0-Linux-x86_64 'https://github.com/docker/compose/releases/download/1.24.0/docker-compose-Linux-x86_64'
  fi

  cp -f docker-compose-1.24.0-Linux-x86_64 /usr/bin/docker-compose
  chmod +x /usr/bin/docker-compose

  if [ ! -f docker-compose-1.24.0-completion-bash ]; then
    wget -O docker-compose-1.24.0-completion-bash 'https://raw.githubusercontent.com/docker/compose/1.24.0/contrib/completion/bash/docker-compose'
  fi

  cp -f docker-compose-1.24.0-completion-bash /etc/bash_completion.d/docker-compose

  if [ ! -f docker-compose-1.24.0-completion-zsh ]; then
    wget -O docker-compose-1.24.0-completion-zsh 'https://raw.githubusercontent.com/docker/compose/1.24.0/contrib/completion/zsh/_docker-compose'
  fi

  cp -f docker-compose-1.24.0-completion-zsh /usr/share/zsh/vendor-completions/_docker-compose
fi

# Hard Disk Sentinel

if [ $HARDWARE -ne 0 ]; then
  if [ ! -f hdsentinel-017-x64.gz ]; then
    wget 'https://www.hdsentinel.com/hdslin/hdsentinel-017-x64.gz'
  fi

  cp -f hdsentinel-017-x64.gz hdsentinel-017-x64-copy.gz
  gzip -d hdsentinel-017-x64-copy.gz
  cp hdsentinel-017-x64-copy /usr/bin/hdsentinel
  chmod +x /usr/bin/hdsentinel
  rm -f hdsentinel-017-x64-copy
fi

# no-ip

if [ ! -f noip-duc-2.1.9-linux.tar.gz ]; then
  wget -O noip-duc-2.1.9-linux.tar.gz 'https://www.noip.com/client/linux/noip-duc-linux.tar.gz'
fi

tar -xf noip-duc-2.1.9-linux.tar.gz
cp noip-2.1.9-1/binaries/noip2-x86_64 /usr/local/bin/noip2
rm -rf noip-2.1.9-1

cat <<EOF > /etc/init.d/noip2
#!/bin/sh
### BEGIN INIT INFO
# Provides: noip2
# Required-Start: \$local_fs \$remote_fs \$network \$syslog \$named
# Required-Stop: \$local_fs \$remote_fs \$network \$syslog \$named
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: NoIP dynamic client
### END INIT INFO

DAEMON=/usr/local/bin/noip2
NAME=noip2

test -x \$DAEMON || exit 0

case "\$1" in
start)
echo -n "Starting dynamic address update: "
start-stop-daemon --start --exec \$DAEMON
echo "noip2."
;;

stop)
echo -n "Shutting down dynamic address update:"
start-stop-daemon --stop --oknodo --retry 30 --exec \$DAEMON
echo "noip2."
;;

restart)
echo -n "Restarting dynamic address update: "
start-stop-daemon --stop --oknodo --retry 30 --exec \$DAEMON
start-stop-daemon --start --exec \$DAEMON
echo "noip2."
;;

*)
echo "Usage: \$0 {start|stop|restart}"
exit 1
esac
exit 0
EOF

chmod +x /etc/init.d/noip2
update-rc.d noip2 defaults

if [ $GUI_ENABLED -ne 0 ]; then
  apt-get install -y \
    chromium \
    conky \
    evince \
    gimp \
    inkscape \
    transmission \
    vlc \
    xfce4 \
    xfce4-goodies

  if [ $HARDWARE -ne 0 ]; then
    apt-get install -y \
      alsa-utils \
      cups \
      simple-scan \
      system-config-printer \
      xcalib
  fi

  # Paper Theme

  if [ ! -f paper-icon-theme_1.5.723-201905252133~daily~ubuntu18.04.1_all.deb ]; then
    wget 'https://launchpadlibrarian.net/425392562/paper-icon-theme_1.5.723-201905252133~daily~ubuntu18.04.1_all.deb'
  fi

  dpkg -i paper-icon-theme_1.5.723-201905252133~daily~ubuntu18.04.1_all.deb ||
    apt-get install -fy

  if [ ! -f paper-gtk-theme.tar.gz ]; then
    wget -O paper-gtk-theme.tar.gz 'https://github.com/snwh/paper-gtk-theme/archive/master.tar.gz'
  fi

  tar -xf paper-gtk-theme.tar.gz
  (cd paper-gtk-theme-master && ./install-gtk-theme.sh)
  rm -rf paper-gtk-theme-master

  # ST

  if [ ! -f st-0.8.2.tar.gz ]; then
    wget 'https://dl.suckless.org/st/st-0.8.2.tar.gz'
  fi

  if [ ! -f https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff ]; then
    wget 'https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff'
  fi

  if [ ! -f st-clipboard-0.8.2.diff ]; then
    wget 'https://st.suckless.org/patches/clipboard/st-clipboard-0.8.2.diff'
  fi

  apt-get install -y gcc libx11-dev libxft-dev libxext-dev make
  tar -xf st-0.8.2.tar.gz

  (
    cd st-0.8.2
    git apply $(find .. -name "st-*.diff")
    sed -i "s/defaultbg = 257/defaultbg = 0/" config.def.h
    sed -i "s/alpha = 0xcc/alpha = 0xdd/" config.def.h
    make clean install
  )

  rm -rf st-0.8.2

  cat <<EOF > /usr/share/applications/simple-terminal.desktop
[Desktop Entry]
Name=st
GenericName=Terminal
Comment=Simple terminal emulator for the X window system
Exec=st
Terminal=false
Type=Application
Encoding=UTF-8
Icon=terminal
Categories=System;TerminalEmulator;
Keywords=shell;prompt;command;commandline;cmd;
EOF

  # Telegram

  if [ ! -f tsetup.1.6.7.tar.xz ]; then
    wget 'https://updates.tdesktop.com/tlinux/tsetup.1.6.7.tar.xz'
  fi

  tar -xf tsetup.1.6.7.tar.xz -C /opt/
  ln -sf /opt/Telegram/Telegram /usr/bin/telegram

  # Vim

  if [ ! -f vim-8.1.tar.bz2 ]; then
    wget 'ftp://ftp.vim.org/pub/vim/unix/vim-8.1.tar.bz2'
  fi

  apt-get purge -fy vim-tiny

  apt-get install -y \
    gcc libncurses-dev libx11-dev libxpm-dev libxt-dev libxtst-dev make

  tar -xf vim-8.1.tar.bz2
  (cd vim81 && ./configure --with-features=huge && make && make install)
  rm -rf vim81

  cat <<EOF > /usr/share/applications/vim.desktop
[Desktop Entry]
Name=Vim
GenericName=Text Editor
Comment=Edit text files
Exec=st vim %F
Terminal=false
Type=Application
Encoding=UTF-8
MimeType=text/plain;
Icon=gvim
Categories=Utility;TextEditor;Development;
Keywords=Text;editor;
EOF

elif [ $GUI_ENABLED -eq 0 ]; then
  # Vim

  if [ ! -f vim-8.1.tar.bz2 ]; then
    wget 'ftp://ftp.vim.org/pub/vim/unix/vim-8.1.tar.bz2'
  fi

  apt-get purge -fy "vim-*"
  apt-get install -y gcc libncurses-dev make
  tar -xf vim-8.1.tar.bz2
  (cd vim81 && ./configure && make && make install)
  rm -rf vim81
fi

############
# Cleaning #
############

apt-get autoremove -y > /dev/null
# shellcheck disable=SC2046
(cd /var/cache/apt && rm -rf $(ls -A))
# shellcheck disable=SC2046
(cd /var/lib/apt/lists && rm -rf $(ls -A))
# shellcheck disable=SC2046
(cd /var/log && rm -rf $(ls -A))


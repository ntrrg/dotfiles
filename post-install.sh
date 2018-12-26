#!/bin/sh

set -e

BASEPATH="${BASEPATH:-/tmp}"
MODE="${MODE:-TEXT}"

apt-get update
apt-get upgrade -y

apt-get install -y \
  apt-transport-https \
  btrfs-progs \
  cryptsetup \
  dosfstools \
  elinks \
  git \
  htop \
  iftop \
  isc-dhcp-client \
  jq \
  lbzip2 \
  lvm2 \
  make \
  megatools \
  mosh \
  netselect \
  ntfs-3g \
  p7zip-full \
  p7zip-rar \
  pciutils \
  pv \
  rsync \
  screen \
  siege \
  shellcheck \
  ssh \
  sshfs \
  transmission-cli \
  usbutils \
  vbetool \
  wget \
  zsh

if lspci | grep -q "Network controller"; then
  apt-get install -y rfkill wicd-curses wireless-tools wpasupplicant
fi

cd "$BASEPATH"

# Busybox

if [ ! -f busybox-1.28.1-x86_64 ]; then
  wget -O busybox-1.28.1-x86_64 'https://busybox.net/downloads/binaries/1.28.1-defconfig-multiarch/busybox-x86_64'
fi

cp -f busybox-1.28.1-x86_64 /bin/busybox
chmod +x /bin/busybox

# Docker

if [ ! -f containerd.io_1.2.0-1_amd64.deb ]; then
  wget 'https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/containerd.io_1.2.0-1_amd64.deb'
fi

if [ ! -f docker-ce_18.09.0~3-0~debian-buster_amd64.deb ]; then
  wget 'https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/docker-ce_18.09.0~3-0~debian-buster_amd64.deb'
fi

if [ ! -f docker-ce-cli_18.09.0~3-0~debian-buster_amd64.deb ]; then
  wget 'https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/docker-ce-cli_18.09.0~3-0~debian-buster_amd64.deb'
fi

dpkg -i \
  containerd.io_1.2.0-1_amd64.deb \
  docker-ce_18.09.0~3-0~debian-buster_amd64.deb \
  docker-ce-cli_18.09.0~3-0~debian-buster_amd64.deb ||
  apt-get install -fy

# Docker Compose

if [ ! -f docker-compose-1.23.2-Linux-x86_64 ]; then
  wget -O docker-compose-1.23.2-Linux-x86_64 'https://github.com/docker/compose/releases/download/1.23.2/docker-compose-Linux-x86_64'
fi

cp -f docker-compose-1.23.2-Linux-x86_64 /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose

if [ ! -f docker-compose-1.23.2-completion-bash ]; then
  wget -O docker-compose-1.23.2-completion-bash 'https://raw.githubusercontent.com/docker/compose/1.23.2/contrib/completion/bash/docker-compose'
fi

cp -f docker-compose-1.23.2-completion-bash /etc/bash_completion.d/docker-compose

if [ ! -f docker-compose-1.23.2-completion-zsh ]; then
  wget -O docker-compose-1.23.2-completion-zsh 'https://raw.githubusercontent.com/docker/compose/1.23.2/contrib/completion/zsh/_docker-compose'
fi

cp -f docker-compose-1.23.2-completion-zsh /usr/share/zsh/vendor-completions/_docker-compose

# ET

if [ ! -f et.sh ]; then
  wget 'https://gist.githubusercontent.com/ntrrg/1dbd052b2d8238fa07ea5779baebbedb/raw/371724030a77113a621fbb7f43b5be506f2eb18d/et.sh'
fi

cp -f et.sh /usr/bin/et
chmod +x /usr/bin/et

# Mage

if [ ! -f mage_1.8.0_Linux-64bit.tar.gz ]; then
  wget -O mage_1.8.0_Linux-64bit.tar.gz 'https://github.com/magefile/mage/releases/download/v1.8.0/mage_1.8.0_Linux-64bit.tar.gz'
fi

tar -xf mage_1.8.0_Linux-64bit.tar.gz
cp -f mage /usr/bin/mage
chmod +x /usr/bin/mage
rm -f LICENSE mage

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

case "$MODE" in
  "TEXT" )
    # Vim

    if [ ! -f vim-8.1.tar.bz2 ]; then
      wget 'ftp://ftp.vim.org/pub/vim/unix/vim-8.1.tar.bz2'
    fi

    apt-get purge -fy vim-tiny
    apt-get install -y gcc libncurses-dev make
    tar -xf vim-8.1.tar.bz2
    (cd vim81 && ./configure && make && make install)
    rm -rf vim81
    ;;

  "GUI" )
    apt-get install -y \
      alsa-utils \
      conky \
      cups \
      evince \
      gimp \
      inkscape \
      simple-scan \
      system-config-printer \
      transmission \
      vlc \
      wicd-gtk \
      xcalib \
      xfce4 \
      xfce4-goodies

    # Chrome

    if [ ! -f google-chrome-stable_71.0.3578.98-1_amd64.deb ]; then
      wget 'http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_71.0.3578.98-1_amd64.deb'
    fi

    dpkg -i google-chrome-stable_71.0.3578.98-1_amd64.deb ||
      apt-get install -fy

    # Paper Theme

    if [ ! -f paper-icon-theme_1.5.721-201808151353~daily~ubuntu18.04.1_all.deb ]; then
      wget 'https://launchpadlibrarian.net/383884507/paper-icon-theme_1.5.721-201808151353~daily~ubuntu18.04.1_all.deb'
    fi

    dpkg -i paper-icon-theme_1.5.721-201808151353~daily~ubuntu18.04.1_all.deb ||
      apt-get install -fy

    if [ ! -f paper-gtk-theme.tar.gz ]; then
      wget -O paper-gtk-theme.tar.gz 'https://github.com/snwh/paper-gtk-theme/archive/master.tar.gz'
    fi

    tar -xf paper-gtk-theme.tar.gz
    (cd paper-gtk-theme-master && ./install-gtk-theme.sh)
    rm -rf paper-gtk-theme-master

    # ST

    if [ ! -f st-0.8.1.tar.gz ]; then
      wget 'https://dl.suckless.org/st/st-0.8.1.tar.gz'
    fi

    apt-get install -y gcc libx11-dev libxft-dev libxext-dev make
    tar -xf st-0.8.1.tar.gz
    (cd st-0.8.1 && make clean install)
    rm -rf st-0.8.1

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

    if [ ! -f tsetup.1.5.4.tar.xz ]; then
      wget 'https://updates.tdesktop.com/tlinux/tsetup.1.5.4.tar.xz'
    fi

    tar -xf tsetup.1.5.4.tar.xz -C /opt/
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
    ;;
esac

apt-get autoremove -y > /dev/null
# shellcheck disable=SC2046
(cd /var/cache/apt && rm -rf $(ls -A))
# shellcheck disable=SC2046
(cd /var/lib/apt/lists && rm -rf $(ls -A))
# shellcheck disable=SC2046
(cd /var/log && rm -rf $(ls -A))


#!/bin/sh

set -e

BASEPATH="${BASEPATH:-/tmp}"

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
  zsh \
  \
  alsa-utils \
  chromium \
  conky \
  cups \
  evince \
  gimp \
  inkscape \
  simple-scan \
  system-config-printer \
  transmission \
  vlc \
  xcalib \
  xfce4 \
  xfce4-goodies

if lspci | grep -q "Network controller"; then
  apt-get install -y rfkill wicd-gtk wireless-tools wpasupplicant
fi

if lsmod | grep -q "bluetooth"; then
  apt-get install -y blueman
fi

cd "$BASEPATH"

# Busybox

if [ ! -f busybox-1.28.1-x86_64 ]; then
  wget -O busybox-1.28.1-x86_64 'https://busybox.net/downloads/binaries/1.28.1-defconfig-multiarch/busybox-x86_64'
fi

cp -f busybox-1.28.1-x86_64 /bin/busybox
chmod +x /bin/busybox

# Docker

if [ ! -f containerd.io_1.2.2-1_amd64.deb ]; then
  wget 'https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/containerd.io_1.2.2-1_amd64.deb'
fi

if [ ! -f docker-ce-cli_18.09.1~3-0~debian-buster_amd64.deb ]; then
  wget 'https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/docker-ce-cli_18.09.1~3-0~debian-buster_amd64.deb'
fi

if [ ! -f docker-ce_18.09.1~3-0~debian-buster_amd64.deb ]; then
  wget 'https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/docker-ce_18.09.1~3-0~debian-buster_amd64.deb'
fi

dpkg -i \
  containerd.io_1.2.0-1_amd64.deb \
  docker-ce-cli_18.09.0~3-0~debian-buster_amd64.deb \
  docker-ce_18.09.0~3-0~debian-buster_amd64.deb ||
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

# golangci-lint

if [ ! -f golangci-lint-1.13.2-linux-amd64.tar.gz ]; then
  wget 'https://github.com/golangci/golangci-lint/releases/download/v1.13.2/golangci-lint-1.13.2-linux-amd64.tar.gz'
fi

tar -xf golangci-lint-1.13.2-linux-amd64.tar.gz
cp -f golangci-lint-1.13.2-linux-amd64/golangci-lint /usr/bin/
chmod +x /usr/bin/golangci-lint
rm -rf golangci-lint-1.13.2-linux-amd64

# Hard Disk Sentinel

if [ ! -f hdsentinel-017-x64.gz ]; then
  wget 'https://www.hdsentinel.com/hdslin/hdsentinel-017-x64.gz'
fi

cp -f hdsentinel-017-x64.gz hdsentinel-017-x64-copy.gz
gzip -d hdsentinel-017-x64-copy.gz
cp hdsentinel-017-x64-copy /usr/bin/hdsentinel
chmod +x /usr/bin/hdsentinel
rm -f hdsentinel-017-x64-copy

# Mage

if [ ! -f mage_1.8.0_Linux-64bit.tar.gz ]; then
  wget 'https://github.com/magefile/mage/releases/download/v1.8.0/mage_1.8.0_Linux-64bit.tar.gz'
fi

tar -xf mage_1.8.0_Linux-64bit.tar.gz
cp -f mage /usr/bin/
chmod +x /usr/bin/mage
rm -f LICENSE mage

# Urchin

if [ ! -f urchin-v0.1.0-rc3 ]; then
  wget -O urchin-v0.1.0-rc3 'https://raw.githubusercontent.com/tlevine/urchin/v0.1.0-rc3/urchin'
fi

cp -f urchin-v0.1.0-rc3 /usr/bin/urchin
chmod +x /usr/bin/urchin

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

if [ ! -f st-alpha-20180616-0.8.1.diff ]; then
  wget 'https://st.suckless.org/patches/alpha/st-alpha-20180616-0.8.1.diff'
fi

if [ ! -f st-clipboard-20180309-c5ba9c0.diff ]; then
  wget 'https://st.suckless.org/patches/clipboard/st-clipboard-20180309-c5ba9c0.diff'
fi

apt-get install -y gcc libx11-dev libxft-dev libxext-dev make
tar -xf st-0.8.1.tar.gz

(
  cd st-0.8.1
  git apply $(find .. -name "st-*.diff")
  sed -i "s/defaultbg = 257/defaultbg = 0/" config.def.h
  sed -i "s/alpha = 0xcc/alpha = 0xdd/" config.def.h
  make clean install
)

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

if [ ! -f tsetup.1.5.11.tar.xz ]; then
  wget 'https://updates.tdesktop.com/tlinux/tsetup.1.5.11.tar.xz'
fi

tar -xf tsetup.1.5.11.tar.xz -C /opt/
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

apt-get autoremove -y > /dev/null
# shellcheck disable=SC2046
(cd /var/cache/apt && rm -rf $(ls -A))
# shellcheck disable=SC2046
(cd /var/lib/apt/lists && rm -rf $(ls -A))
# shellcheck disable=SC2046
(cd /var/log && rm -rf $(ls -A))


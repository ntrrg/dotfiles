#!/bin/sh

set -e

BASEPATH="${BASEPATH:-/tmp}"
IS_HARDWARE="${IS_HARDWARE:-1}"

################
# Installation #
################

cd "$BASEPATH"

apt-get update
apt-get upgrade -y

apt-get install -y \
  apt-transport-https \
  bc \
  elinks \
  git \
  htop \
  iftop \
  isc-dhcp-client \
  jq \
  lbzip2 \
  locales \
  make \
  man \
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

if [ "$HARDWARE" -ne 0 ]; then
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
    apt-get install -y rfkill wicd-curses wireless-tools wpasupplicant
  fi

  if lsmod | grep -q "bluetooth"; then
    apt-get install -y blueman
  fi
fi

localedef -ci "en_US" -f "UTF-8" -A "/usr/share/locale/locale.alias" \
  "en_US.UTF-8"

# Hard Disk Sentinel

if [ "$HARDWARE" -ne 0 ]; then
  if [ ! -f "hdsentinel-017.gz" ]; then
    wget 'https://www.hdsentinel.com/hdslin/hdsentinel-017.gz'
  fi

  cp -f "hdsentinel-017.gz" "hdsentinel-017-copy.gz"
  gzip -d "hdsentinel-017-copy.gz"
  cp "hdsentinel-017-copy" "/usr/bin/hdsentinel"
  chmod +x "/usr/bin/hdsentinel"
  rm -f "hdsentinel-017-copy"
fi

# no-ip

if [ ! -f "noip-duc-2.1.9-linux.tar.gz" ]; then
  wget -O "noip-duc-2.1.9-linux.tar.gz" \
    'https://www.noip.com/client/linux/noip-duc-linux.tar.gz'
fi

tar -xf "noip-duc-2.1.9-linux.tar.gz"
cp "noip-2.1.9-1/binaries/noip2-i686" "/usr/local/bin/noip2"
rm -rf "noip-2.1.9-1"

cat <<EOF > "/etc/init.d/noip2"
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

chmod +x "/etc/init.d/noip2"
update-rc.d noip2 defaults

# Vim

if [ ! -f "vim-8.2.tar.bz2" ]; then
  wget 'ftp://ftp.vim.org/pub/vim/unix/vim-8.2.tar.bz2'
fi

apt-get purge -fy "vim-*"
apt-get install -y gcc libncurses-dev make
tar -xf "vim-8.2.tar.bz2"
(cd "vim82" && "./configure" && make && make install)
rm -rf "vim82"

############
# Cleaning #
############

apt-get autoremove -y > "/dev/null"
find "/var/cache/apt/" -mindepth 1 -delete
find "/var/lib/apt/lists/" -mindepth 1 -delete
find "/var/log/" -mindepth 1 -delete


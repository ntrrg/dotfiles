#!/bin/sh

set -e

BASEPATH="${BASEPATH:-/tmp}"
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
  lbzip2 \
  locales \
  mosh \
  netselect \
  pv \
  rsync \
  screen \
  ssh \
  transmission-cli \
  unzip \
  wget \
  zsh

localedef -ci en_US -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

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
    apt-get install -y rfkill wicd-curses wireless-tools wpasupplicant
  fi
fi

# Busybox

if [ ! -f busybox-1.28.1-i686 ]; then
  wget -O busybox-1.28.1-i686 'https://busybox.net/downloads/binaries/1.28.1-defconfig-multiarch/busybox-i686'
fi

cp -f busybox-1.28.1-i686 /bin/busybox
chmod +x /bin/busybox

# Hard Disk Sentinel

if [ $HARDWARE -ne 0 ]; then
  if [ ! -f hdsentinel-017.gz ]; then
    wget 'https://www.hdsentinel.com/hdslin/hdsentinel-017.gz'
  fi

  cp -f hdsentinel-017.gz hdsentinel-017-copy.gz
  gzip -d hdsentinel-017-copy.gz
  cp hdsentinel-017-copy /usr/bin/hdsentinel
  chmod +x /usr/bin/hdsentinel
  rm -f hdsentinel-017-copy
fi

# no-ip

if [ ! -f noip-duc-2.1.9-linux.tar.gz ]; then
  wget -O noip-duc-2.1.9-linux.tar.gz 'https://www.noip.com/client/linux/noip-duc-linux.tar.gz'
fi

tar -xf noip-duc-2.1.9-linux.tar.gz
cp noip-2.1.9-1/binaries/noip2-i686 /usr/local/bin/noip2
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

# Vim

if [ ! -f vim-8.1.tar.bz2 ]; then
  wget 'ftp://ftp.vim.org/pub/vim/unix/vim-8.1.tar.bz2'
fi

apt-get purge -fy vim-tiny
apt-get install -y gcc libncurses-dev make
tar -xf vim-8.1.tar.bz2
(cd vim81 && ./configure && make && make install)
rm -rf vim81

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


#!/bin/sh

set -e

BASEPATH="${BASEPATH:-/tmp}"

is_container() {
  if cat /proc/self/cgroup | grep -q "docker/"; then
    return 0
  fi

  if cat /proc/self/cgroup | grep -q "kubepods/"; then
    return 0
  fi

  if [ -n "$CONTAINER" ]; then
    return 0
  fi

  return 1
}

cd "$BASEPATH"

apt-get update
apt-get upgrade -y

apt-get install -y \
  apt-transport-https \
  elinks \
  git \
  htop \
  iftop \
  mosh \
  netselect \
  pv \
  rsync \
  screen \
  ssh \
  transmission-cli \
  wget \
  zsh

if ! is_container; then
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

# Busybox

if [ ! -f busybox-1.28.1-x86_64 ]; then
  wget -O busybox-1.28.1-x86_64 'https://busybox.net/downloads/binaries/1.28.1-defconfig-multiarch/busybox-x86_64'
fi

cp -f busybox-1.28.1-x86_64 /bin/busybox
chmod +x /bin/busybox

# Docker

if ! is_container; then
  if [ ! -f containerd.io_1.2.5-1_amd64.deb ]; then
    wget 'https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/containerd.io_1.2.5-1_amd64.deb'
  fi

  if [ ! -f docker-ce-cli_18.09.5~3-0~debian-stretch_amd64.deb ]; then
    wget 'https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce-cli_18.09.5~3-0~debian-stretch_amd64.deb'
  fi

  if [ ! -f docker-ce_18.09.5~3-0~debian-stretch_amd64.deb ]; then
    wget 'https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce_18.09.5~3-0~debian-stretch_amd64.deb'
  fi

  dpkg -i \
    containerd.io_1.2.5-1_amd64.deb \
    docker-ce-cli_18.09.5~3-0~debian-stretch_amd64.deb \
    docker-ce_18.09.5~3-0~debian-stretch_amd64.deb ||
  apt-get install -fy
fi

# Hard Disk Sentinel

if ! is_container; then
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

# Vim

if [ ! -f vim-8.1.tar.bz2 ]; then
  wget 'ftp://ftp.vim.org/pub/vim/unix/vim-8.1.tar.bz2'
fi

apt-get purge -fy vim-tiny
apt-get install -y gcc libncurses-dev make
tar -xf vim-8.1.tar.bz2
(cd vim81 && ./configure && make && make install)
rm -rf vim81

# Cleaning

apt-get autoremove -y > /dev/null
# shellcheck disable=SC2046
(cd /var/cache/apt && rm -rf $(ls -A))
# shellcheck disable=SC2046
(cd /var/lib/apt/lists && rm -rf $(ls -A))
# shellcheck disable=SC2046
(cd /var/log && rm -rf $(ls -A))


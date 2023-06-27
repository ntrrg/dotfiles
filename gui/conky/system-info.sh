#!/bin/sh

set -eo pipefail

##########
# System #
##########

export BIOS_VENDOR="$(cat /sys/class/dmi/id/bios_vendor | sed "s/ Inc\.//g")"
export BIOS_VERSION="$(cat /sys/class/dmi/id/bios_version)"
export BIOS_RELEASE="$(cat /sys/class/dmi/id/bios_release)"
export HW_VENDOR="$(cat /sys/class/dmi/id/sys_vendor | sed "s/ Inc\.//g")"
export HW_MODEL="$(cat /sys/class/dmi/id/product_name)"

export DISTRIBUTION="$(
  cat /etc/os-release |
  grep '^PRETTY_NAME=' |
  cut -d '"' -f 2
)"

export MB_VENDOR="$(cat /sys/class/dmi/id/board_vendor | sed "s/ Inc\.//g")"
export MB_MODEL="$(cat /sys/class/dmi/id/board_name)"

###########
# Compute #
###########

CPU_INFO="$(lscpu)"
CPU_DMI="$(/usr/sbin/dmidecode -t 4)"

export CPU_WORD="$(
  echo "$CPU_INFO" |
  grep '^CPU op-mode(s):' |
  grep -q '64-bit' &&
    echo "64-bit" || echo "32-bit"
)"

export CPU_MODEL="$(
  echo "$CPU_INFO" |
  grep '^Model name:' |
  tail -n 1 |
  sed 's/.*: *//' |
  tr -s ' ' ' '
)"

export CPU_SOCKET="$(
  echo "$CPU_DMI" |
  grep ' *Socket Designation:' |
  sed 's/.*: *//' |
  tr -s ' ' ' '
)"

export CPU_ENDIANNESS="$(
  echo "$CPU_INFO" |
  grep '^Byte Order:' |
  tail -n 1 |
  sed 's/.*: *//'
)"

export CPU_MIN_MHZ="$(
  echo "$CPU_INFO" |
  grep '^CPU min MHz' |
  tail -n 1 |
  sed 's/.*: *//' |
  cut -d '.' -f 1
)"

export CPU_MAX_MHZ="$(
  echo "$CPU_INFO" |
  grep '^CPU max MHz' |
  tail -n 1 |
  sed 's/.*: *//' |
  cut -d '.' -f 1
)"

export CPU_CORES="$(
  echo "$CPU_INFO" |
  grep '^CPU(s):' |
  tail -n 1 |
  sed 's/.*: *//'
)"

export CPU_THREADS="$((($(
  echo "$CPU_INFO" |
  grep '^Thread(s) per core:' |
  tail -n 1 |
  sed 's/.*: *//'
) * CPU_CORES)))"

export CPU_FAN_RPM="N/A"

##########
# Memory #
##########

MEM_ARRAY_DMI="$(/usr/sbin/dmidecode -t 16)"
MEMS_DMI="$(/usr/sbin/dmidecode -t 17)"

export MEM_SOCKETS="$(
  echo "$MEM_ARRAY_DMI" |
  grep ' *Number Of Devices:' |
  sed 's/.*: *//' |
  tr -s ' ' ' '
)"

export MEM_MAX_SIZE="$(
  echo "$MEM_ARRAY_DMI" |
  grep ' *Maximum Capacity:' |
  sed 's/.*: *//' |
  sed 's/ //'
)"

export MEM_FORM_FACTOR="$(
  echo "$MEMS_DMI" |
  grep ' *Form Factor:' |
  head -n 1 |
  sed 's/.*: *//' |
  tr -s ' ' ' '
)"

export MEM_TYPE="$(
  echo "$MEMS_DMI" |
  grep ' *Type:' |
  head -n 1 |
  sed 's/.*: *//' |
  tr -s ' ' ' '
)"

export MEM_MODULES=""
MEM_MODS="$(echo "$MEMS_DMI" | grep '^Handle' | grep -o '0x[0-9a-fA-F]\+')"

for HANDLE in $MEM_MODS; do
  MEM_MOD_DMI="$(/usr/sbin/dmidecode -H "$HANDLE")"

  MEM_MOD_VENDOR="$(
    echo "$MEM_MOD_DMI" |
    grep ' *Manufacturer:' |
    sed 's/.*: *//' |
    tr -s ' ' ' '
  )"

  MEM_MOD_SIZE="$(
    echo "$MEM_MOD_DMI" |
    grep ' *Size:' |
    sed 's/.*: *//' |
    sed 's/ //'
  )"

  MEM_MOD_SPEED="$(
    echo "$MEM_MOD_DMI" |
    grep 'Speed:' |
    head -n 1 |
    sed 's/.*: *//' |
    sed 's/ //'
  )"

  MEM_MOD_MODEL="$(
    echo "$MEM_MOD_DMI" |
    grep ' *Part Number:' |
    sed 's/.*: *//' |
    sed 's/ \+$//' |
    tr -s ' ' ' '
  )"

  MEM_MODULES="$MEM_MODULES* $MEM_MOD_VENDOR $MEM_MOD_SIZE $MEM_MOD_SPEED ($MEM_MOD_MODEL)
"
done

###########
# Storage #
###########

SDA_SMARTCTL="$(/usr/sbin/smartctl -i /dev/sda)"

export SDA_MODEL="$(
  echo "$SDA_SMARTCTL" |
  grep '^Device Model:' |
  sed 's/.*: *//'
)"

export SDA_SERIAL="$(
  echo "$SDA_SMARTCTL" |
  grep '^Serial Number:' |
  sed 's/.*: *//'
)"

export SDA_RPM="$(
  echo "$SDA_SMARTCTL" |
  grep '^Rotation Rate' |
  grep -oe '[0-9]\+' ||
    echo "N/A"
)"

if [ "$SDA_RPM" != "N/A" ]; then
  SDA_RPM="${SDA_RPM}RPM"
fi

export SDA_TEMP="$(
  /usr/sbin/smartctl -A /dev/sda |
  grep "Temperature_Celsius" |
  tr -s ' ' ' ' |
  cut -d ' ' -f 10
)"


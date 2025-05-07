#!/bin/sh

set -xeuo pipefail

CLEAR_RULES="${FIREWALL_CLEAR_RULES:-0}"
ALLOW_MOSH="${ALLOW_MOSH:-1}"
ALLOW_SSH="${ALLOW_SSH:-1}"

if [ "$CLEAR_RULES" -eq 1 ]; then
	iptables -Z
	iptables -F
fi

iptables -P INPUT DROP
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT

if [ "$ALLOW_SSH" -eq 1 ]; then
	iptables -A INPUT -p tcp --dport 22 -j ACCEPT
fi

if [ "$ALLOW_MOSH" -eq 1 ]; then
	iptables -A INPUT -p udp --dport 60000:61000 -j ACCEPT
fi

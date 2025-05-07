# /etc/wireguard/postup.sh

# https://gist.github.com/qdm12/4e0e4f9d1a34db9cf63ebb0997827d0d

INTERFACE=wg0
WIREGUARD_LAN=10.11.0.0/24
MASQUERADE_INTERFACE=wlan0

sysctl net.ipv4.ip_forward=1
iptables -t nat -I POSTROUTING -o $MASQUERADE_INTERFACE -j MASQUERADE -s $WIREGUARD_LAN

# Add a WIREGUARD_wg0 chain to the FORWARD chain
# CHAIN_NAME="WIREGUARD_$INTERFACE"
# iptables -N $CHAIN_NAME
# iptables -A FORWARD -j $CHAIN_NAME
#
# # Accept related or established traffic
# iptables -A $CHAIN_NAME -o $INTERFACE -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#
# ##################################
# # TRUSTED CLIENT (10.11.0.100)
# ## Accept and forward _all traffic_ from the Wireguard IP address of the trusted client. No restrictions.
# iptables -A $CHAIN_NAME -s 10.11.0.100 -i $INTERFACE -j ACCEPT
# ##################################
#
# ##################################
# # GUEST (10.11.0.3)
# ## Allow guest to use a DNS that runs in your LAN(192.168.0.53) e.g. Pihole.
# ### This requires the guest to set the DNS server in the Wireguard config: `DNS = 192.168.0.53`.
# ### Remove if not necessary.
# iptables -A $CHAIN_NAME -s 10.11.0.3 -i $INTERFACE -p udp --dport 53 -d 192.168.0.53 -j ACCEPT
#
# ## Allow guest to access a HTTP server running in a LAN host(192.168.0.30).
# ### Remove if not necessary.
# iptables -A $CHAIN_NAME -s 10.11.0.3 -i $INTERFACE -p tcp --match multiport --dport 80,443 -d 192.168.0.30 -j ACCEPT
#
# ## Prevent guest from accessing **this** host. The one running the Wireguard server(192.168.0.10).
# ### Depending on your needs and setup, you might need to also create a rule for the Wireguard IP of the server too. Check first.
# ### IMPORTANT: this is an INPUT rule as we don't want "INPUT" to this host. Other rules stay as FORWARD because they are for other hosts.
# ### IMPORTANT: If used, add to the postdown.sh: iptables -D INPUT -s 10.11.0.3 -i $INTERFACE -p tcp -d 192.168.0.10 -j DROP
# ### Remove if not necessary.
# iptables -A INPUT -s 10.11.0.3 -i $INTERFACE -p tcp -d 192.168.0.10 -j DROP
#
# ## Drop traffic to any LAN or Wireguard IP address.
# iptables -A $CHAIN_NAME -s 10.11.0.3 -i $INTERFACE -d 10.11.0.0/24,192.168.0.0/24 -j DROP
#
# ## Accept outgoing connections to the Internet.
# iptables -A $CHAIN_NAME -s 10.11.0.3 -i $INTERFACE -d 0.0.0.0/0 -j ACCEPT
# ##################################
#
# # Drop everything else coming through the Wireguard interface
# iptables -A $CHAIN_NAME -i $INTERFACE -j DROP
#
# # Return to FORWARD chain
# iptables -A $CHAIN_NAME -j RETURN

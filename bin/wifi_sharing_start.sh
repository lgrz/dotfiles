#!/bin/bash

# Start sharing internet over WiFi.

if (( $EUID != 0 )); then
    echo "Not root user, exit."
    exit 1
fi

LAN=enp0s25
WAN=wlp3s0

# enable ip forwarding
sysctl net.ipv4.ip_forward=1

# configure static ip
# note: ifup will run iptables-restore, so use iproute2 tools directly.
ip link set dev $LAN up
ip address add 192.168.10.1/24 dev $LAN

# allow packets coming from the internet to be translated, `MASQUERADE` has to
# inspect every packet but it works for dynamic ip addresses on the WAN. For
# more see iptables-extensions manpage.
iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE

# The next two rules are `-I` inserted, so they show up in reverse order in
# iptables. They are `-I` inserted to work with existing rules in the firewall
# setup.
#
# Forward traffic coming in from LAN and out to WAN
iptables -I FORWARD -i $LAN -o $WAN -j ACCEPT
# Match on `conntrack` extension module, for connection tracking states
# `RELATED` and `ESTABLISHED` i.e. existing connections already seen in both
# directions.
iptables -I FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Print the rules
iptables -L -nv
iptables -t nat -L -nv

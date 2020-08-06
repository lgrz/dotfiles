#!/bin/bash

# Stop sharing internet over WiFi.

if (( $EUID != 0 )); then
    echo "Not root user, exit."
    exit 1
fi

# disable ip forwarding
sysctl net.ipv4.ip_forward=0

# Reset all iptables rules
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X

# Restore the firewall rules
iptables-restore < /etc/iptables.up.rules

# Print the rules
iptables -L -nv
iptables -t nat -L -nv

#!/bin/bash
#https://ubuntu.com/server/docs/using-the-vpn-as-the-default-gateway

sudo apt update -y
sudo apt install wireguard -y

# GENERATE KEY PAIRS FOR BOTH SERVER AND CLIENT, DO NOT RE-USE THESE!!!

# PRIV_SERV=8P2j7w0C+Z4oiChma3jysOPBGQ+Ba32RTC4UIj8nHHE=
# PUB_SERV=WNUYkJNCUtZCqexI5askIt2Ye2IqqMeEC2Mvq2hQGws=
# PUB_PEER=AlOenPNFbW9dnMNvzYki7j5emBb6eJKlkS2VmbrD80I=

ufw allow 51820/udp

echo "net.ipv4.ip_forward = 1" >  /etc/sysctl.d/70-wireguard-routing.conf
sudo sysctl -p /etc/sysctl.d/70-wireguard-routing.conf -w


echo "[Interface]
Address = 10.2.0.1/24
SaveConfig = true
PrivateKey = ${PRIV_SERV}
PostUp = iptables -t nat -I POSTROUTING -o enX0 -j MASQUERADE
PreDown = iptables -t nat -D POSTROUTING -o enX0 -j MASQUERADE

ListenPort = 51820

[Peer]
PublicKey = ${PUB_PEER}
AllowedIPs = 10.8.0.2/32
" > /etc/wireguard/wg0.conf


wg-quick up wg0


#________________________________
# 54.91.130.99
# PRIV_PEER=yAmtJY95q6syvBSaEer7Gc5A6s9/0nLOEKmyZqdkcUY=

# [Interface]
# PrivateKey = yAmtJY95q6syvBSaEer7Gc5A6s9/0nLOEKmyZqdkcUY=    # Client-Private-Key
# Address = 10.8.0.2/24
# DNS = 172.31.0.2        # Default DNS server for EC2s

# [Peer]
# PublicKey = WNUYkJNCUtZCqexI5askIt2Ye2IqqMeEC2Mvq2hQGws=     # Server-Public-Key
# AllowedIPs = 0.0.0.0/0
# Endpoint = 54.91.130.99:51820
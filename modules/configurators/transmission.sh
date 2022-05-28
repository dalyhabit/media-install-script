#!/bin/bash

unset provider
while [[ "" = $provider ]]; do
    read -p "Enter your VPN provider ID from https://haugene.github.io/docker-transmission-openvpn/supported-providers/: " provider
done

unset region
while [[ "" = $region ]]; do
    read -p "Enter your VPN region. You can find a list at https://github.com/haugene/vpn-configs-contrib/tree/main/openvpn: " region
done

unset username
while [[ "" = $username ]]; do
    read -p "Enter your VPN username/email: " username
done

unset password
while [[ "" = $password ]]; do
    read -s -p "Enter your VPN password. For security, no characters will appear: " password
done
echo

export provider
export region
export username
export password
#!/bin/bash

echo -e """  transmission:
    container_name: transmission
    cap_add:
      - NET_ADMIN
    volumes:
      - '${downloads}:/storage/downloads'
    environment:
      - OPENVPN_PROVIDER=${provider}
      - OPENVPN_CONFIG=${region}
      - OPENVPN_USERNAME=${username}
      - OPENVPN_PASSWORD=${password}
      - TRANSMISSION_DOWNLOAD_DIR=/storage/downloads
      - TRANSMISSION_SEED_QUEUE_ENABLED=true
      - LOCAL_NETWORK=$(ip -o -f inet addr show $(ip route list | awk '/^default/ {print $5}') | awk '{print $4}' | cut -d"." -f1-3).0/24
    logging:
      driver: json-file
      options:
        max-size: 10m
    ports:
      - '9091:9091'
    image: haugene/transmission-openvpn
    restart: unless-stopped"""
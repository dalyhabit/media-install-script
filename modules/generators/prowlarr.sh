#!/bin/bash
echo -e """  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=$(cat /etc/timezone)
    volumes:
      - ${config}/prowlarr:/config
    ports:
      - 9696:9696
    restart: unless-stopped"""
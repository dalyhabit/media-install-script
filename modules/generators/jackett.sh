#!/bin/bash
echo -e """  jackett:
    image: lscr.io/linuxserver/jackett:latest
    container_name: jackett
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=$(cat /etc/timezone)
    volumes:
      - ${config}/jackett:/config
    ports:
      - 9117:9117
    restart: unless-stopped"""
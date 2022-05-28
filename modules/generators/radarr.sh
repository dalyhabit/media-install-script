#!/bin/bash
echo -e """  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
        - PUID=1000
        - PGID=1000
        - TZ=$(cat /etc/timezone)
    volumes:
        - ${config}/radarr:/config
        - ${storage}:/storage
    ports:
        - 7878:7878
    restart: unless-stopped"""
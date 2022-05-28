#!/bin/bash
echo -e """  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
        - PUID=1000
        - PGID=1000
        - TZ=$(cat /etc/timezone)
    volumes:
        - ${config}/sonarr:/config
        - ${storage}:/storage
    ports:
        - 8989:8989
    restart: unless-stopped"""
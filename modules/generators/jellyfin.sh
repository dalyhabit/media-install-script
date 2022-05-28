#!/bin/bash
echo -e """  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=$(cat /etc/timezone)
    volumes:
      - ${config}/jellyfin:/config
      - ${media}:/media:ro
    ports:
      - 8096:8096    
    devices:
      - /dev/video10:/dev/video10
      - /dev/video11:/dev/video11
      - /dev/video12:/dev/video12 
    restart: unless-stopped"""
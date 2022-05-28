#!/bin/bash
echo -e """  emby:
    image: lscr.io/linuxserver/emby:latest
    container_name: emby
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=$(cat /etc/timezone)
    volumes:
      - ${config}/emby:/config
      - ${media}:/media:ro
    ports:
      - 8096:8096
    devices:
      - /dev/video10:/dev/video10
      - /dev/video11:/dev/video11
      - /dev/video12:/dev/video12 
    restart: unless-stopped"""
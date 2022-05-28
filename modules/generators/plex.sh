#!/bin/bash
echo -e """  plex:
    image: lscr.io/linuxserver/plex:latest
    container_name: plex
    environment:
      - PUID=1000
      - PGID=1000
      - VERSION=docker
      - PLEX_CLAIM=${plex_claim}
    volumes:
      - ${config}/plex:/config
      - ${media}:/media:ro
    ports:
        32400:32400
    restart: unless-stopped"""
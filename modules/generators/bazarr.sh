#!/bin/bash
echo -e """  bazarr:
    image: lscr.io/linuxserver/bazarr:latest
    container_name: bazarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - ${config}/bazarr:/config
      - ${storage}/media/movies:/storage/media/movies
      - ${storage}/media/tv:/storage/media/tv
    ports:
      - 6767:6767
    restart: unless-stopped"""
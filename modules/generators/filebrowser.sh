#!/bin/bash
echo -e """  filebrowser:
    image: hurlenko/filebrowser
    container_name: filebrowser
    user: "1000:1000"
    ports:
      - 443:8080
    volumes:
      - ${storage}:/storage
      - ${config}/filebrowser:/config
    environment:
      - FB_BASEURL=/filebrowser
    restart: always"""
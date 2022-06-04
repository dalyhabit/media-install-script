#!/bin/bash
echo -e """  filebrowser:
    image: filebrowser/filebrowser
    container_name: filebrowser
    user: "1000:1000"
    ports:
      - 8080:80
    volumes:
      - ${storage}:/srv
      - ${config}/filebrowser/settings.json:/.filebrowser.json
      - ${config}/filebrowser/db:/database
    restart: always"""

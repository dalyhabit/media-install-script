#!/bin/bash
echo -e """  requestrr:
    image: darkalfx/requestrr
    container_name: requestrr
    environment:
        - PUID=1000
        - PGID=1000
        - TZ=$(cat /etc/timezone)
    volumes:
        - ${config}/requestrr:/config
    ports:
        - 4545:4545
    restart: unless-stopped"""
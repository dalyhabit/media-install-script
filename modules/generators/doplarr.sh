#!/bin/bash
echo -e """  doplarr:
    image: lscr.io/linuxserver/doplarr:latest
    container_name: doplarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=$(cat /etc/timezone)
      # - DISCORD__TOKEN=
      # - OVERSEERR__API=
      # - OVERSEERR__URL=http://overseerr:5055
      # - RADARR__API=
      # - RADARR__URL=http://radarr:7878
      # - SONARR__API=
      # - SONARR__URL=http://sonarr:8989
      # - DISCORD__MAX_RESULTS=25 #optional
      # - DISCORD__REQUESTED_MSG_STYLE=:plain #optional
      # - SONARR__QUALITY_PROFILE= #optional
      # - RADARR__QUALITY_PROFILE= #optional
      # - SONARR__ROOTFOLDER= #optional
      # - RADARR__ROOTFOLDER= #optional
      # - SONARR__LANGUAGE_PROFILE= #optional
      # - OVERSEERR__DEFAULT_ID= #optional
      # - PARTIAL_SEASONS=true #optional
      # - LOG_LEVEL=:info #optional
      # - JAVA_OPTS= #optional
    volumes:
      - ${config}/doplarr:/config
    restart: unless-stopped"""
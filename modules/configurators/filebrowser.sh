#!/bin/bash

mkdir -p $config/filebrowser/db
chown 1000:1000 $config/filebrowser/db

curl -fsSL https://raw.githubusercontent.com/filebrowser/filebrowser/master/docker/root/defaults/settings.json -o $config/filebrowser/settings.json
chown 1000:1000 $config/filebrowser/settings.json

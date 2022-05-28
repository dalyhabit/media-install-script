#!/bin/bash

# assert sudo
if [ $(whoami) != "root" ]; then
    echo "This script requires root, read more at #TODO GIT README"
    exit
fi

# Install git
apt-get update
apt-get install git

#store user pwd
oldcwd=$(pwd)

# Download the full installer
cd /tmp
git clone https://gitlab.com/mediaguides/media-install-script.git
# Download the submodules
cd media-install-script
git submodule update
# Run the full installer
chmod +x run.sh
bash run.sh

# Go back to user pwd
cd $oldcwd

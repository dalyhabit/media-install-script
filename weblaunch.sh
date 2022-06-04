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
if [[ ! -d /tmp/media/install-script ]]; then
    cd /tmp
    git clone https://gitlab.com/mediaguides/media-install-script.git
fi
# Download the submodules
cd /tmp/media-install-script
git submodule update
# Run the full installer
chmod +x run.sh
bash run.sh

# Go back to user pwd
cd $oldcwd

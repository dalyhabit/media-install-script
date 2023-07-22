#!/bin/bash

# empty variables
unset storage
unset media
unset downloads
unset jackett
unset emby
unset plex
unset jellyfin
unset radarr
unset sonarr
unset transmission
unset watchtower

# assert sudo
if [ $(whoami) != "root" ]; then
    echo "This script requires root, read more at #TODO GIT README"
    exit
fi

echo "Updating package lists"
# update package lists
apt-get update > /dev/null
# do a general update
apt-get upgrade -y > /dev/null
# test docker
docker version > /dev/null 2>/dev/null
if [ $? != 0 ]; then
# install docker/docker-compose
    chmod +x ./modules/installers/docker-install/install.sh
    bash ./modules/installers/docker-install/install.sh > /dev/null
fi

# Check if we have a disk
fdisk -l /dev/sda > /dev/null 2> /dev/null
if [ $? = 0 ]; then
    # Get drive name
    drive=$(fdisk -l /dev/sda | sed -rn 's~Disk model: (.+)\s+~\1~ip')
    echo "Detected external device: '$drive'"
    read -p "Do you wish to format this drive? [y/N] " yn
    if [[ "$yn" =~ ^[yY]$ ]]; then
        read -p "Enter the drive name to confirm format: " driveconfirm
        if [[ $drive = $driveconfirm ]]; then
            if [[ ! -d "/mnt/external" ]]; then
                mkdir /mnt/external
            fi
            read -p "Do you wish to use LVM (expandable; not compatible with Windows/Mac): [y/N] " yn
            if [[ "$yn" =~ ^[yY]$ ]]; then
                read -p "We will format '$drive' for LVM, type 'confirm' to proceed. " confirm
                if [[ "$confirm" = "confirm" ]]; then
                    dd if=/dev/zero of=/dev/sda count=8196 2> /dev/null
                    pvcreate /dev/sda36 > /dev/null
                    vgcreate LVMVolGroup /dev/sda > /dev/null
                    lvcreate -l 100%FREE -n storage LVMVolGroup > /dev/null
                    mkfs.ext4 /dev/LVMVolGroup/storage > /dev/null
                    echo "Format complete"
                    echo "/dev/LVMVolGroup/storage /mnt/external ext4 defaults,nofail,uid=1000,gid=1000,umask=022 0 0" >> /etc/fstab
                else
                    exit 1
                fi
            else
                read -p "We will format '$drive' for ntfs, type 'confirm' to proceed: " confirm
                if [[ "$confirm" = "confirm" ]]; then
                    dd if=/dev/zero of=/dev/sda count=8196 2> /dev/null
                    echo "n
                    p
                    1


                    w" | fdisk /dev/sda > /dev/null
                    mkfs.ntfs -f /dev/sda1 > /dev/null
                    echo "Format complete"
                    echo "/dev/sda1 /mnt/external ntfs defaults,nofail,uid=1000,gid=1000,umask=022 0 0" >> /etc/fstab
                else
                    exit 1
                fi
            fi
            mount -a
            chown 1000:1000 /mnt/external
        else
            echo "Aborting Setup"
            exit 1
        fi
    else
        echo "Skipping format"
    fi
fi

# prompt filestore
read -p "Enter location to create the compose file [/app]: " appdata
[ "$appdata" = "" ] && appdata="/app"
export appdata=$appdata

if [[ ! -d $appdata ]]; then
    mkdir -p $appdata
fi

unset storage
while [[ ! -d $storage ]]; do
    read -p "Enter root storage directory: [/mnt/external]: " storage
    [ "$storage" = "" ] && storage="/mnt/external"
done
read -p "Enter configuration subroot: $storage/" config
[ "$config" = "" ] && config="config" && echo "    Defaulting to $storage/config"
read -p "Enter media subroot: $storage/" media
[ "$media" = "" ] && media="media" && echo "    Defaulting to $storage/media"
read -p "Enter download subroot: $storage/" downloads
[ "$downloads" = "" ] && downloads="downloads" && echo "   Defaulting to $storage/downloads"

# append filestore
export storage
export config=$storage/$config
export media=$storage/$media
export downloads=$storage/downloads

# create subdirs
if [[ ! -d $media/tv ]]; then
    mkdir $media/tv
fi

if [[ ! -d $media/movies ]]; then
    mkdir $media/movies
fi

# prompt submodules
read -p "Use Watchtower (enables auto-update)? [Y/n] " yn
if [[ "$yn" =~ ^[yY]*$ ]]; then
    watchtower=$(bash ./modules/generators/watchtower.sh)
fi

read -p "Use filebrowser (web-based file management)? [Y/n] " yn
if [[ "$yn" =~ ^[yY]*$ ]]; then
    bash ./modules/configurators/filebrowser.sh && export filebrowser=$(bash ./modules/generators/filebrowser.sh)
fi

read -p "Use Jackett? [Y/n] " yn
if [[ "$yn" =~ ^[yY]*$ ]]; then
    jackett=$(bash ./modules/generators/jackett.sh)
fi

read -p "Use Sonarr? [Y/n] " yn
if [[ "$yn" =~ ^[yY]*$ ]]; then
    sonarr=$(bash ./modules/generators/sonarr.sh)
fi

read -p "Use Radarr? [Y/n] " yn
if [[ "$yn" =~ ^[yY]*$ ]]; then
    radarr=$(bash ./modules/generators/radarr.sh)
fi

read -p "Use Transmission? [Y/n] " yn
if [[ "$yn" =~ ^[yY]*$ ]]; then
    source ./modules/configurators/transmission.sh && export transmission=$(bash ./modules/generators/transmission.sh)
fi

read -p "Use Requestrr? [Y/n] " yn
if [[ "$yn" =~ ^[yY]*$ ]]; then
    source ./modules/configurators/requestrr.sh && export requestrr=$(bash ./modules/generators/requestrr.sh)
fi

read -p "Use Emby? [y/N] " yn
if [[ "$yn" =~ ^[yY]$ ]]; then
    emby=$(bash ./modules/generators/emby.sh)
fi

read -p "Use Jellyfin? [y/N] " yn
if [[ "$yn" =~ ^[yY]$ ]]; then
    jellyfin=$(bash ./modules/generators/jellyfin.sh)
fi

read -p "Use Plex? [y/N] " yn
if [[ "$yn" =~ ^[yY]$ ]]; then
    read -p "Retrieve a claim code from https://plex.tv/claim and enter it here: " plex_claim
    export plex_claim
    plex=$(bash ./modules/generators/plex.sh)
fi

# generate compose
echo -e """
version: '3.3'
services:""" > ${appdata}/docker-compose.yml

[ ${watchtower+x} ] && echo -e "$watchtower" >> ${appdata}/docker-compose.yml
[ ${filebrowser+x} ] && echo -e "$filebrowser" >> ${appdata}/docker-compose.yml
[ ${jackett+x} ] && echo -e "$jackett" >> ${appdata}/docker-compose.yml
[ ${sonarr+x} ] && echo -e "$sonarr" >> ${appdata}/docker-compose.yml
[ ${radarr+x} ] && echo -e "$radarr" >> ${appdata}/docker-compose.yml
[ ${requestrr+x} ] && echo -e "$requestrr" >> ${appdata}/docker-compose.yml
[ ${transmission+x} ] && echo -e "$transmission" >> ${appdata}/docker-compose.yml
[ ${emby+x} ] && echo -e "$emby" >> ${appdata}/docker-compose.yml
[ ${jellyfin+x} ] && echo -e "$jellyfin" >> ${appdata}/docker-compose.yml
[ ${plex+x} ] && echo -e "$plex" >> ${appdata}/docker-compose.yml

# start compose
cd ${appdata}
docker compose up -d
cd ${OLDPWD}

# Wait for transmission
curl -I http://localhost:9091 >/dev/null 2> /dev/null
while [[  $? -ne 0 ]]; do
    sleep 5
    echo "Waiting 5s for transmission to come online..."
    curl -I http://localhost:9091 >/dev/null 2> /dev/null
done

# Run autoconf
ip=$(ip -o -f inet addr show $(ip route list | awk '/^default/ {print $5}') | awk '{print $4}' | cut -d"/" -f1)
if [ ${sonarr+x} ]; then
    read -p "Please ensure Sonarr is running at http://$ip:8989, then press any key to continue with autoconfiguration."
    bash ./modules/postinstall/sonarr.sh >/dev/null 2>/dev/null
fi

if [ ${radarr+x} ]; then
    read -p "Please ensure Radarr is running at http://$ip:7878, then press any key to continue with autoconfiguration."
    bash ./modules/postinstall/radarr.sh >/dev/null 2>/dev/null
fi

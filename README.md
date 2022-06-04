# Raspberry Pi Media Streambox Guide

## Introduction
This guide is a successor to the [original guide available on r/Piracy](https://www.reddit.com/r/Piracy/comments/ma1hlm/the_complete_guide_to_building_your_own_personal/) and is designed to be more user-friendly and cost accessible.

The install script is compatible with any Ubuntu host, not just the Raspberry Pi.  If you have an extra PC around and would prefer to use that instead, follow the [official Ubuntu server install guide](https://ubuntu.com/tutorials/install-ubuntu-server) and skip to [running the install script](#running the install script).

If you have any critiques or suggestions, please leave a comment so that I can continue to improve this guide.

### Hardware List

#### Raspberry Pi 4 Model B
The device at the heart of this guide is the [Raspberry Pi Model B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/), suggested to be the 4 or 8 GB version.  The Pi is a low-power computing device running a fast ARM64 chip, and is able to serve multiple media streams simultaneously.

#### MicroSD Card
The MicroSD card can be any size above 32GB, which is the minimum recommendation for this guide.  A U3/V30 speed rating is recommended for good filesystem performance.

**Recommendation**: Sandisk Extreme microSDXC [32GB](https://amzn.to/3lU72Xm)/[64GB](https://amzn.to/3MYCYFY).

#### Case, Fan & Power Supply
The case is technically optional but is recommended to prevent dust accumulation.  A fan or aluminum heat fin is recomended (ideally both) to dissipate the heat produced by the chip, especially if utilizing transcoding.  Pick a power supply able to deliver at least 15 Watts.

**Recommendation**: [iUniker Rasperry Pi Case & 17.5W Power Supply](https://amzn.to/38wB54A).

#### External Hard Drive
The MicroSD card is small and slow.  For utilizing an external HDD as your main media and database storage, at least 4TB is recommended but you can never have too much disk space.  I recommend buying at the top of your budget, because it is difficult to add more drives later.

**Recommendation**: Western Digital Elements Desktop hard drive.  Available in [4](https://amzn.to/3x4c2PT)/[6](https://amzn.to/3GpV0OU)/[8](https://amzn.to/3lPf2Jg)/[10](https://amzn.to/3lNK4Br)/[12](https://amzn.to/38qq8kP)/[14](https://amzn.to/3N3Jmfq)/[16](https://amzn.to/3wVSm0v)/[18](https://amzn.to/3a2X8Aj)TB options, they frequently go on sale and are fairly quiet.


## OS Install
1. Insert your MicroSD card to your PC
2. Download the official [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and install/run it
3. [Click "Choose OS"](./images/imager_1.png)
4. [Select "Other general-purpose OS"](./images/imager_2.png)
5. [Select "Ubuntu"](./images/imager_3.png)
6. [Select "Ubuntu Server 22.04 LTS"](./images/imager_4.png)
7. [Click "Choose Storage"](./images/imager_5.png) and select the SD card matching the capacity of yours.  If there is more than one option, be very careful and unplug any storage devices before proceeding.
8. Click "Write" and wait for the drive to be formatted and written.

## Hardware Setup

1. Attach the heatsinks.
2. Assemble the case and plug in the fan
3. Insert the formatted SD card
4. Attach the power and ethernet cables, and (optional) connect a keyboard and monitor.

## Logging in
Download an SSH client.  This can be [PuTTY for Window](https://www.puttygen.com/download-putty#Download_PuTTY_073_for_Windows), or Terminal for Mac, or your favorite TTY if using Linux.
### Connect via hostname (1st Method)
1. Use "ubuntu" as Host Name in PuTTY, or type `ssh ubuntu@ubuntu` into Terminal if using Mac
2. If you are prompted for a password, your router has found the Rasperry Pi on the network and you can proceed to ["Running the Install Script"](#running-the-install-script).  The default password is `ubuntu`.
3. If you could not connect, you must find the IP address of the Raspberry Pi on your network.

### Connect via IP Address (2nd Method)
1. If your router has an app or web page that allows you to see devices, look for a device labeled "Ubuntu" or has a MAC/hardware address starting with "e4:5f:01".
2. Alternatively, you can attach a monitor and keyboard to the Pi.  The default username is `ubuntu` and the default password is `ubuntu`. You will be asked to change the password once you log in.  Once the password has changed, type the command `ip addr show | grep eth0` and find the IP address beginning with `192.168`, `172.`, or `10.`
3. Return to your computer and provide the IP address into PuTTY or type `ssh ubuntu@xxx.xxx.xxx.xx`, replacing the `x` with the IP address you found.

## Running the Install Script
The first thing you are required to do when logged in is to change the password.  When typing passwords in the Linux shell, no characters are displayed but your input is still recorded.

Once logged in, running the install script is just two commands:

> curl -fsSL https://gitlab.com/mediaguides/media-install-script/-/raw/master/weblaunch.sh -o weblaunch.sh && sudo bash weblaunch.sh

Follow the on-screen instructions.  If you get stuck, refer to the [debugging](#debugging) section or look at the comments.

## Configuring the Services
From here on out, you can leave puTTY/ssh alone, the configuration can be done from a web browser.  Remember the hostname/ip address you connected to for the next section.

### Jackett
Jackett is only as good as the trackers you have added to it.  Navigate to `http://serverIP:9117` where `serverIP` is the IP address or hostname of the Linux server.

Add a few indexers using the "add indexer" button.  It may feel like a good idea to add a lot, but that increases search times for every single search.

Congrats!  You now have a multi-tracker search engine at your fingertips, or more importantly, the fingertips of Sonarr and Radarr.  Keep this window open as we move to the next configuration step.

### Radarr
Navigate to `http://serverIP:7878` in order to access the Radarr console.  Next, go to Indexers.  Enable "Show Advanced" at the top menu bar under search.  For each of the indexers you added to Jackett, do the following

* Press the add symbol
* Select Torznab
* Go back to the Jackett window and click "copy Torznab Feed" for your index
* Paste in the URL box, but change `http://serverIP:9117` to `http://jackett:9117`.  The docker containers address each other by their container name, not by your server's IP.
* Copy the API key from Jackett (in the top right)

If you see a warning like
> This indexer does not support any of the selected categories! (You may need to turn on advanced settings to see them)

You'll need to go back into Jackett, hit the wrench for the indexer causing the issue, and search for the category of "Movies."  There are sometimes several.  Copy each category you wish to search (for example, don't include Movies/x265/4k if you don't intend to watch 4K movies) and paste them, separated by commas, into the "Categories" box in Radarr.

Once done, it's time to add our first movie and define the destination paths for our downloads.

Search up a movie (preferably one that's recent and has seeders) in the top bar and select the correct movie.  When the popup appears, click under "Root Folder" and select "Add a new path".  Fill in the text field with `/storage/media/movies` and press "OK".  Select the quality profile desired (otherwise, it will select the most seeded) and check "Start search for missing movie".

View your transmission progress at `http://serverIP:9091`.  The download should be added and everything should begin working.   When the download finishes, the file will be "hard linked" to the `/mnt/external/media/movies` directory in a new organized folder.  This enables you to seed your entire collection while also maintaining an organized file structure.  Deleting from the `/mnt/external/downloads` directory will **not** save you any space, because the two files point to the same 1's and 0's on your hard disk.  Additionally, when you want to delete a movie from your collection, make sure it is also deleted from `/mnt/data/downloads`.  If you opted to use filebrowser, you can delete from both of these directories at http://serverIP:8080

Finally, we're going to authentication-lock Radarr by going to Settings -> General and selecting "Basic".  Choose a username and password, but be aware that Radarr does not transmit the password securely.  This is optional but highly recommended.

### Sonarr
Radarr is based on Sonarr and the same steps above should be followed, but this time at `http://serverIP:8989`.

The only other difference is that you should use the `/storage/media/tv` directory as your "Root Folder" in order to keep the two libraries distinct for Plex.

If you opted for authentication on Radarr, you should do so on Sonarr with the **same** username and password.  Otherwise, some web browsers will get confused.

## Appendix
### Downloading Misc Torrents in the VPN Tunnel

The VPN tunnel is capable of downloading more than just media.  You can add torrent files and magnet URIs in transmission at http://serverIP:9091, then download them in filebrowser at http://serverIP:8080.

### Changing the docker-compose.yml

In order to make changes to the runtime configuration, you will need to modify `docker-compose.yml`.  Connect in the same way you did to run the install script (puTTY/ssh) and type `sudo nano /app/docker-compose.yml`.  You will be dropped into a keyboard-only text editor.  Use the arrow keys to make changes, then save with `control-o`, `enter` and exit with `control-x`.

Once changes are made, restart the runtime with the changes: `cd /app && sudo docker compose up -d`

### Debugging
#### `Waiting 5s for transmission to come online...`

This bug is displayed when transmission does not completely finish initializing.  This could be due to a number of things, but the easiest way to check is to check the log.  Press `control-c` to break out of the install script, then type `docker logs -f transmission` and look for relevant log entries.  Specifically, look for `authentication failed`, `connection timed out`, or the last log entry for each startup (transmission will continue to restart even as it has errors).  The [official issues tracker](https://github.com/haugene/docker-transmission-openvpn/issues?q=is%3A+issue) is a good place to look for solutions.

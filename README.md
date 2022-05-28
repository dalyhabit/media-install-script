# Raspberry Pi Media Seedbox Guide

## Introduction
This guide is a successor to the original guide available on [r/Piracy](https://www.reddit.com/r/Piracy/comments/ma1hlm/the_complete_guide_to_building_your_own_personal/) and is designed to be more user-friendly and cost accessible.

If you have any critiques or suggestions, please leave a comment so that I can continue to improve this guide.

### Hardware List

#### Raspberry Pi 4 Model B
The device at the heart of this guide is the [Raspberry Pi Model B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/), suggested to be the 4 or 8 GB version.  The Pi is a low-power computing device running a fast ARM64 chip, and is able to serve multiple media streams simultaneously.

#### MicroSD Card
The MicroSD card can be any size above 32GB, which is the minimum recomendation for this guide.  A U3/V30 speed rating is recomended for good filesystem performance.

**Recommendation**: Sandisk Extreme microSDXC [32GB](https://amzn.to/3lU72Xm)/[64GB](https://amzn.to/3MYCYFY).

#### Case, Fan & Power Supply
The case is technically optional, but recomended to prevent desk accumulation.  A fan or aluminum heat fin is recomended (ideally both) to dissappate the heat produced by the chip, especially if utilizing transcoding.  Pick a power supply able to deliver at least 15 Watts.

**Recommendation**: [iUniker Rasperry Pi Case & 17.5W Power Supply](https://amzn.to/38wB54A).

#### External Hard Drive
The MicroSD card is small and slow.  For utilizing an external HDD as your main media and database storage, at least 4TB is recomended but you can never have too much disk space.  I recommend buying at the top of your budget, because it is difficult to add more drives later.

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
Once logged in, running the install script is just two commands:
> curl -fsSL https://gitlab.com/mediaguides/media-install-script/-/raw/master/weblaunch.sh -o weblaunch.sh

> sudo bash weblaunch.sh

## Configuring the Services
### Jackett
Jackett is only as good as the trackers you have added to it.  Navigate to `http://serverIP:9117` where `serverIP` is the IP address or local hostname of the Linux server.

Add a few indexers using the "add indexer" button.  It may feel like a good idea to add a lot, but that increases search times for every single search.

Congrats!  You now have a multi-tracker search engine at your fingertips, or more importantly, the fingertips of Sonarr and Radarr.  Keep this window open as we move to the next configuration step.

### Radarr

Navigate to `http://serverIP:7878` in order to access the Radarr console.  We're going to change a few settings, starting with "Download Clients."

Next, go to Indexers.  Enable "Show Advanced" at the top menu bar under search.  For each of the indexers you added to Jackett, do the following

* Press the add symbol
* Select Torznab
* Go back to the Jackett window and click "copy Torznab Feed" for your index
* Paste in the URL box, but change `http://serverIP:9117` to `http://jackett:9117`.  The docker containers address each other by their container name, not by your server's IP.
* Copy the API key from Jackett (in the top right)

If you see a warning like
> This indexer does not support any of the selected categories! (You may need to turn on advanced settings to see them)

You'll need to go back into Jackett, hit the wrench for the indexer causing the issue, and search for the category of "Movies."  There are sometimes several.  Copy each category you wish to search (for example, don't include Movies/x265/4k if you don't intend to watch 4K movies) and paste them, separated by commas, into the "Categories" box in Radarr.

Once done, it's time to add our first movie and define the destination paths for our downloads.

Search up a movie (preferably one that's recent and has seeders) in the top bar and select the correct movie.  When the popup appears, click under "Root Folder" and select "Add a new path".  Fill in the typing bar with `/storage/media/movies/` and press "OK".  Select the quality profile desired (otherwise, it will select the most seeded) and check "Start search for missing movie".

View your transmission progress at `http://serverIP:9091`.  The download should be added and everything should begin working.   When the download finishes, the file will be "hard linked" to the `/mnt/external/media/movies` directory in a new organized folder.  This enables you to seed your entire collection while also maintaining an organized file structure.  Deleting from the `/mnt/external/downloads` directory will **not** save you any space, because the two files point to the same 1's and 0's on your hard disk.  Similarly, when you want to delete a movie from your collection, make sure it is also deleted from `/mnt/data/downloads`.

Finally, we're going to authentication-lock Radarr by going to Settings -> General and selecting "Basic".  Choose a username and password, but be aware that Radarr does not transmit the password securely.  This is optional but highly recommended.

### Sonarr
Radarr is based on Sonarr and the same steps above should be followed, but this time at `http://serverIP:8989`.

The only other difference is that you should use the `/storage/media/tv` directory as your "Root Folder" in order to keep the two libraries distinct for Plex.

If you opted for authentication on Radarr, you should do so on Sonarr with the **same** username and password.  Otherwise, some web browsers will get confused.


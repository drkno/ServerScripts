#!/bin/bash

printf "\033[1;93m  _____         _______ _     _\n |_____] |      |______  \\___/ \n |       |_____ |______ _/   \\_\n Copyright (c) Matthew Knox 2017\n\n\033[0m"
echo "This script is avalible under the MIT license. It is incomplete and will fail."
echo "Good luck."

mkdir -p /mnt/download
mkdir -p /mnt/media
mkdir -p /mnt/plexdrive
mkdir -p /mnt/upload
mkdir -p /var/local/work

add-apt-repository ppa:transmissionbt/ppa
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC
echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

apt-get update
apt-get install install transmission-cli transmission-common transmission-daemon nzbdrone unzip mongodb-org lighttpd

rm -rf /etc/update-motd.d/*
rsync --exclude 'autosetup.sh' --exclude 'README.md' -a ./ /

ln -s /opt/status.sh /usr/bin/status
ln -s /opt/manual_upload.sh /usr/bin/manual_upload

wget $(curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep browser_download_url | grep linux -m 1 | cut -d '"' -f 4)
mkdir -p /opt/Radarr
tar -xvzf Radarr.develop.*.linux.tar.gz Radarr -C /opt/Radarr
rm Radarr.develop.*.linux.tar.gz

wget $(curl -s https://api.github.com/repos/Jackett/Jackett/releases | grep browser_download_url | grep tar.gz -m 1 | cut -d '"' -f 4)
mkdir -p /opt/Jackett
tar -xvzf Jackett.Binaries.*.tar.gz Jackett -C /opt/Jackett
rm Jackett.Binaries.*.tar.gz

wget $(curl -s https://api.github.com/repos/tidusjar/Ombi/releases | grep browser_download_url -m 1 | cut -d '"' -f 4)
mkdir -p /opt/Ombi
unzip -d /opt/Ombi Ombi.zip
rm Ombi.zip

chmod -R 777 /opt # enable self-updaters

wget $(curl -s https://api.github.com/repos/dweidenfeld/plexdrive/releases | grep browser_download_url | grep amd64 -m 1 | cut -d '"' -f 4)
mv plexdrive* /usr/bin/plexdrive
chmod +x /usr/bin/plexdrive

bash -c "$(wget -qO - https://raw.githubusercontent.com/mrworf/plexupdate/master/extras/installer.sh)"

cp /usr/share/zoneinfo/Pacific/Auckland /etc/localtime

systemctl daemon-reload

systemctl enable jackett.service
systemctl enable mnt-media.automount
systemctl enable ombi.service
systemctl enable plexdrive.service
systemctl enable rclone-download.service
systemctl enable sonarr.service
systemctl enable transmission-daemon.service

systemctl start jackett.service
systemctl start mnt-media.automount
systemctl start ombi.service
systemctl start plexdrive.service
systemctl start rclone-download.service
systemctl start sonarr.service
systemctl start transmission-daemon.service
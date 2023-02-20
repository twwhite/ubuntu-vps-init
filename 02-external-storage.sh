#!/bin/bash

NON_ROOT_USER=tim
EXT_MOUNT_DIR=/home/$NON_ROOT_USER/twio
REMOTE_BASE_DIR=/0

sudo mkdir -p $EXT_MOUNT_DIR
sudo chown -R $NON_ROOT_USER:$NON_ROOT_USER $EXT_MOUNT_DIR

read -p "Enter Hetzner Storage Box User ID: " HETZNER_ID
read -p "Enter Hetzner Storage Box Password: " HETZNER_PW

sudo echo "username=$HETZNER_ID" >> /etc/backup-credentials.txt
sudo echo "password=$HETZNER_PW" >> /etc/backup-credentials.txt

sudo echo "//$HETZNER_ID.your-storagebox.de/backup$REMOTE_BASE_DIR $EXT_MOUNT_DIR cifs iocharset=utf8,rw,mfsymlinks,credentials=/etc/backup-credentials.txt,uid=$NON_ROOT_USER,gid=$NON_ROOT_USER,file_mode=0660,dir_mode=0770 0 0" >> /etc/fstab



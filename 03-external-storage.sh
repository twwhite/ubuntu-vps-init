#!/bin/bash

NON_ROOT_USER=tim
EXT_MOUNT_DIR=/mnt/twio
IDENTITY_FILE=/home/$NON_ROOT_USER/.ssh/twio_storage_box
REMOTE_BASE_DIR=/0

if test -f "$IDENTITY_FILE"; then
     echo "== Init External Storage =="
else
     echo "$IDENTITY_FILE does not exist. Please add this file to continue."
     exit 1
fi

sudo mkdir -p $EXT_MOUNT_DIR
sudo chown -R $NON_ROOT_USER:$NON_ROOT_USER $EXT_MOUNT_DIR

read -p "Enter Remote Server: "
read -p "Enter Remote User: "

# Enable auto-mount on reboot
echo "== Enabling Auto-mount on Reboot =="
mkdir -p /home/$NON_ROOT_USER/scripts/recurring/
echo -e "#!/bin/bash\nsshfs $REMOTE_USER@$REMOTE_SERVER:$REMOTE_BASE_DIR $EXT_MOUNT_DIR -o IdentityFile=$IDENTITY_FILE,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3\nsleep 30\nsyncthing & disown" > /home/$NON_ROOT_USER/scripts/recurring/reboot.sh
sudo chmod a+x /home/$NON_ROOT_USER/scripts/recurring/reboot.sh

line="@reboot /home/$NON_ROOT_USER/scripts/recurring/reboot.sh"
(crontab -u $NON_ROOT_USER -l; echo "$line" ) | crontab -u $NON_ROOT_USER -

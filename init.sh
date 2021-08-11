#!/bin/bash

# server updates
sudo apt update && sudo apt -y upgrade && sudo apt autoremove && apt autoclean && echo "Up to date."

# UFW firewall
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
echo "UFW enabled & ssh, http, https allowed"

# Add non-root user & copy root key
sudo adduser tim
mkdir /home/tim/.ssh
sudo cp /root/.ssh/authorized_keys /home/tim/.ssh/
chown -R tim:tim /home/tim/.ssh
chmod 700 /home/tim/.ssh
chmod 600 /home/tim/.ssh/authorized_keys

# ssh: disallow passwords & root login
sed -i '/PasswordAuthentication/d' /etc/ssh/sshd_config
sed -i '/PermitRootLogin/d' /etc/ssh/sshd_config
echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
service ssh restart

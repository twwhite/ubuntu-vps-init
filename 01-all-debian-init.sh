#!/bin/bash

# Server basics
NON_ROOT_USER=tim
DIST=$(awk -F= '/^NAME/{print $2};' /etc/os-release)

apt install -y sudo ssh
sudo timedatectl set-timezone America/Los_Angeles
sudo apt update && sudo apt -y upgrade && sudo apt autoremove && sudo apt autoclean
echo "Up to date!"

# UFW firewall
sudo apt install -y ufw
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
echo "UFW enabled with ssh, http, https allowed"

sudo adduser $NON_ROOT_USER
sudo usermod -aG sudo $NON_ROOT_USER

# Fail2ban
sudo apt install -y fail2ban
echo "Fail2ban installed and started with default settings"

# SSH setup
mkdir /home/$NON_ROOT_USER/.ssh
chown -R $NON_ROOT_USER:$NON_ROOT_USER /home/$NON_ROOT_USER/.ssh
chmod 700 /home/$NON_ROOT_USER/.ssh
chmod 600 /home/$NON_ROOT_USER/.ssh/authorized_keys

sed -i '/PasswordAuthentication/d' /etc/ssh/sshd_config
sed -i '/PermitRootLogin/d' /etc/ssh/sshd_config
echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
echo 'PermitRootLogin no' >> /etc/ssh/sshd_config

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILwLqOxPSMliEIreWGLD0fX/h90JGz5P4MDIwIEFIEuB tim@timwhite.io" >> /home/$NON_ROOT_USER/.ssh/authorized_keys
service ssh restart

# Other Essentials
sudo apt install -y vim zip unzip sshfs cifs-utils apache2-utils

# Create Swap File
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Syncthing
sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
sudo apt-get update
sudo apt-get install syncthing

# Services
cp -r ./services/user/* /etc/systemd/user/

cd /home/$NON_ROOT_USER/.config/systemd
systemctl --user start  *
systemctl --user enable *

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

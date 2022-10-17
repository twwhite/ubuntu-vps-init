#!/bin/bash

nonRootUsername=tim
dist=$(awk -F= '/^NAME/{print $2};' /etc/os-release)



# If for whatever reason...
apt install -y  sudo curl ssh

sudo apt update && sudo apt -y upgrade && sudo apt autoremove && apt autoclean && echo "Up to date."

# Set Timezone America/New_York
sudo timedatectl set-timezone America/Los_Angeles

# UFW firewall
sudo apt install -y ufw
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
echo "UFW enabled & ssh, http, https allowed"

# Add non-root user & copy root key (Assumes vps provider preloads this ssh key, otherwise need to add it manually)
sudo groupadd docker
sudo adduser $nonRootUsername
sudo usermod -aG sudo $nonRootUsername
sudo usermod -aG docker $nonRootUsername
sudo usermod -aG www-data $nonRootUsername

mkdir /home/$nonRootUsername/.ssh
sudo cp /root/.ssh/authorized_keys /home/$nonRootUsername/.ssh/
chown -R $nonRootUsername:$nonRootUsername /home/$nonRootUsername/.ssh
chmod 700 /home/$nonRootUsername/.ssh
chmod 600 /home/$nonRootUsername/.ssh/authorized_keys

# zsh, oh my zsh, zshrc, batcat
sudo apt install -y zsh bat
sudo -u $nonRootUsername sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo -u $nonRootUsername mkdir -p /home/$nonRootUsername/.local/bin
sudo -u $nonRootUsername ln -s /usr/bin/batcat /home/$nonRootUsername/.local/bin/bat
sudo -u $nonRootUsername chsh -s /usr/bin/zsh root

# ssh: disallow passwords & root login
sed -i '/PasswordAuthentication/d' /etc/ssh/sshd_config
sed -i '/PermitRootLogin/d' /etc/ssh/sshd_config
echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
service ssh restart

# Docker
sudo apt install -y php apt-transport-https ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

if [[ "$dist" == *"Debian"* ]]; then
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
elif [[ "$dist" == *"Ubuntu"* ]]; then
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

sudo apt update

# Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Other essentials for remote host
sudo apt install -y rclone borgbackup php php-mbstring php-xml php-curl ffmpeg zip unzip php-zip
sudo apt install docker-ce docker-ce-cli containerd.io

# Check if root data directory exists, e.g. has been successfully mounted
check_file="twio_data_root_dir"
found=$(find / -name $check_file)
if [ -n "$found" ]; then
        dir=${found::-${#check_file}}
        echo "Root data dir found at $dir"
        echo $dir >> /home/$nonRootUsername/twio_data_root_ref
else
        echo "Root data dir not found."
fi

service nginx stop
systemctl disable nginx
service apache2 stop
systemctl disable apache2

echo "Rebooting..."
sudo reboot

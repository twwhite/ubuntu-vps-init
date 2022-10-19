#!/bin/bash

NON_ROOT_USER=tim
DIST=$(awk -F= '/^NAME/{print $2};' /etc/os-release)

# Updates
sudo apt update && sudo apt -y upgrade && sudo apt autoremove && apt autoclean
echo "Up to date."

# Add non_root_user to appropriate groups
sudo groupadd docker
sudo usermod -aG docker $NON_ROOT_USER
sudo usermod -aG www-data $NON_ROOT_USER

# zsh, oh my zsh, zshrc, batcat
sudo apt install -y zsh bat
sudo -u $nonRootUsername sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo -u $nonRootUsername mkdir -p /home/$nonRootUsername/.local/bin
sudo -u $nonRootUsername ln -s /usr/bin/batcat /home/$nonRootUsername/.local/bin/bat
sudo -u $nonRootUsername chsh -s /usr/bin/zsh root

# ssh: disallow passwords & root login
sudo sed -i '/PasswordAuthentication/d' /etc/ssh/sshd_config
sudo sed -i '/PermitRootLogin/d' /etc/ssh/sshd_config
sudo echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
sudo echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
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
sudo apt install -y vim rclone borgbackup php php-mbstring php-xml php-curl ffmpeg zip unzip php-zip
sudo apt install docker-ce docker-ce-cli containerd.io

# Check if root data directory exists, e.g. has been successfully mounted
#check_file="twio_data_root_dir"
#found=$(find / -name $check_file)
#if [ -n "$found" ]; then
#        dir=${found::-${#check_file}}
#        echo "Root data dir found at $dir"
#        echo $dir >> /home/$nonRootUsername/twio_data_root_ref
#else
#        echo "Root data dir not found."
#fi

sudo service nginx stop
sudo systemctl disable nginx
sudo service apache2 stop
sudo systemctl disable apache2

echo "Rebooting..."
sudo reboot

#!/bin/bash

# set flag to stop if error
set -e

# Enable verbose debugging - shows each command before executing
set -x

#init git (run without sudo to configure for current user, not root)
./git_init.sh

echo "====== GIT INIT COMPLETE ======"

# Install
echo "====== STARTING APT INSTALLATIONS ======"
sudo apt install -y wget \
curl \
vim \
gpg \
fzf \
timeshift \
flameshot \
neofetch \
tmux \
neovim \
gh \
i3 \
polybar \
htop \
make \
unzip \
gcc \
zoxide \
ripgrep

echo "====== APT INSTALLATIONS COMPLETE ======"

# Install eza
echo "====== INSTALLING EZA ======"
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

echo "====== EZA COMPLETE ======"

#kitty
echo "====== INSTALLING KITTY ======"
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

echo "====== KITTY COMPLETE ======"

# Flathub software
echo "====== INSTALLING FLATPAK APPS ======"
flatpak install -y flathub \
com.spotify.Client \
org.gimp.GIMP \
net.cozic.joplin_desktop \
org.videolan.VLC \
com.discordapp.Discord \
org.gnome.Boxes

echo "====== FLATPAK APPS COMPLETE ======"

# Install Hack Nerd font
echo "====== INSTALLING NERD FONT ======"
sudo ./install_nerdfont.sh Hack

echo "====== NERD FONT COMPLETE ======"

# remove old docker packages
echo "====== REMOVING OLD DOCKER PACKAGES ======"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

echo "====== OLD DOCKER PACKAGES REMOVED ======"

#Install docker with script
echo "====== INSTALLING DOCKER ======"
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh

# Add docker group and user to this
# Can be skipped, but docker will require sudo
echo "====== CONFIGURING DOCKER GROUP ======"
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker # can be replaced by system reboot
echo "docker group has been made, to test run 'docker run hello-world'"

echo "====== DOCKER COMPLETE ======"

 #install or update go
 echo "====== INSTALLING GO ======"
 sudo ./get_go.sh
 
 # Go Environment Variables, need to be set in each session (.bashrc)
echo "====== GO COMPLETE ======"

 # Go Environment Variables, need to be set in each session (.bashrc)
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

#lazygit & lazydocker
echo "====== INSTALLING LAZYGIT & LAZYDOCKER ======"
go install github.com/jesseduffield/lazygit@latest
go install github.com/jesseduffield/lazydocker@latest

echo "====== LAZYGIT & LAZYDOCKER COMPLETE ======"

# Latest php
echo "====== INSTALLING PHP ======"
sudo ./install_php.sh

echo "====== PHP COMPLETE ======"

# Enable Firewall
echo "====== ENABLING FIREWALL ======"
sudo ufw enable

echo "====== ALL INSTALLATIONS COMPLETE ======"

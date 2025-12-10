#!/bin/bash

# set flag to stop if error
set -e

# Enable verbose debugging - shows each command before executing
set -x

# Also log to a file for review
exec 2> >(tee -a "/tmp/ubuntu_install_debug.log" >&2)

#init git (run without sudo to configure for current user, not root)
./git_init.sh

# Install
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

# Install eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

#kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Flathub software
flatpak install -y flathub \
com.spotify.Client \
org.gimp.GIMP \
net.cozic.joplin_desktop \
org.videolan.VLC \
com.discordapp.Discord \
org.gnome.Boxes

# Install Hack Nerd font
sudo ./install_nerdfont.sh Hack

# remove old docker packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

#Install docker with script
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh

# Add docker group and user to this
# Can be skipped, but docker will require sudo
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker # can be replaced by system reboot
echo "docker group has been made, to test run 'docker run hello-world'"

 #install or update go
 sudo ./get_go.sh
 
 # Go Environment Variables, need to be set in each session (.bashrc)
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

#lazygit & lazydocker
go install github.com/jesseduffield/lazygit@latest
go install github.com/jesseduffield/lazydocker@latest

# Latest php
sudo ./install_php.sh

# Enable Firewall
sudo ufw enable

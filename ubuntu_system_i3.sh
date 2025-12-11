#!/bin/bash

# set flag to stop if error
set -e

# Enable verbose debugging - shows each command before executing
set -x

# Function to wait for apt lock to be released
wait_for_apt() {
    echo "Checking for apt locks..."

    # Stop packagekitd if it's running (common culprit for locks)
    if systemctl is-active --quiet packagekit; then
        echo "Stopping packagekit service..."
        sudo systemctl stop packagekit
        sudo systemctl mask packagekit
    fi

    # Wait for any remaining locks
    local max_attempts=30
    local attempt=0
    while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || \
          sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || \
          sudo fuser /var/cache/apt/archives/lock >/dev/null 2>&1; do
        attempt=$((attempt + 1))
        if [ $attempt -ge $max_attempts ]; then
            echo "ERROR: Waited too long for apt lock. Trying to force release..."
            sudo killall apt apt-get dpkg packagekitd 2>/dev/null || true
            sudo rm -f /var/lib/apt/lists/lock
            sudo rm -f /var/cache/apt/archives/lock
            sudo rm -f /var/lib/dpkg/lock-frontend
            sudo dpkg --configure -a
            break
        fi
        echo "Waiting for other apt processes to finish... (attempt $attempt/$max_attempts)"
        sleep 2
    done
    echo "Apt lock released, continuing..."
}

#init git (run without sudo to configure for current user, not root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$SCRIPT_DIR/git_init.sh"

echo "====== GIT INIT COMPLETE ======"

# Install
echo "====== STARTING APT INSTALLATIONS ======"
wait_for_apt
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
wait_for_apt
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

echo "====== EZA COMPLETE ======"

#kitty
echo "====== INSTALLING KITTY ======"
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
sudo ln -s $HOME/.local/kitty.app/bin/kitty /usr/local/bin/

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

# Install Hack Nerd font used as default so included
echo "====== INSTALLING NERD FONT ======"
sudo bash "$SCRIPT_DIR/install_nerdfont.sh" Hack

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
# Create docker group only if it doesn't exist
if ! getent group docker > /dev/null 2>&1; then
    sudo groupadd docker
    echo "Docker group created"
else
    echo "Docker group already exists"
fi
sudo usermod -aG docker $USER
echo "User added to docker group. Log out and back in for changes to take effect."
echo "To test docker without logging out, run: newgrp docker && docker run hello-world"

echo "====== DOCKER COMPLETE ======"

 #install or update go
 # Go is needed as default for installing LAZY
 echo "====== INSTALLING GO ======"
 sudo bash "$SCRIPT_DIR/get_go.sh"
 
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

# Enable Firewall
echo "====== ENABLING FIREWALL ======"
sudo ufw enable

echo "====== ALL INSTALLATIONS COMPLETE ======"

# On first run do system upgrade
sudo apt update && sudo apt upgrade -y

# Install
sudo apt install -y git \
wget \
curl \
vim \
gpg \
fzf \
timeshift \
extrepo \
flameshot \
neofetch

# Install eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

# Install librewolf
sudo extrepo enable librewolf
sudo apt update && sudo apt install librewolf -y
# remove firefox
sudo apt purge firefox
sudo apt autoremove

# Flathub software
flatpak install -y flathub \
com.spotify.Client \
org.gimp.GIMP \
net.cozic.joplin_desktop \
org.videolan.VLC \
com.discordapp.Discord

# Enable Firewall
sudo ufw enable

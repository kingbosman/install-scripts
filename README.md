# install-scripts
Repo for all install scripts used in my configs

# Go Environment Variables
put these in you `.bashrc`
```
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

# Notes
Use dotfiles repo for installing dotfiles

# Setup
```
sudo apt update && sudo apt upgrade -y
sudo apt install -y git
git clone https://github.com/kingbosman/install-scripts.git /tmp/install-scripts
chmod +x /tmp/install-scripts/ubuntu-system_i3.sh
. /tmp/install-scripts/ubuntu_system_i3.sh
```

# Post Setup
You can run any of the remaining install scripts
The following have been covered in ubuntu-system script
* git (can be run again to update details)
* go (can be run again to update)
* Hack Nerdfont (the script can be run again with the font name as argument)

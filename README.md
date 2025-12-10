# install-scripts
Repo for all install scripts used in my configs

-- go paths
# Go Environment Variables
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Notes
Use dotfiles repo for installing dotfiles

# Setup
```
sudo apt update && sudo apt upgrade -y
sudo apt install -y git
mkdir ~/projects/github.com/kingbosman -p
git clone https://github.com/kingbosman/install-scripts.git
```

#!/bin/bash

# set flag to stop if error
set -e

sudo apt install -y tmux \
	neovim \
	gh \
	i3 \
	lazygit \
	lazydocker \
 	htop \
  	make \
   	unzip \
	gcc \
 	ripgrep
  	  	
# TODO: docker
 # later also python php go nvm/npm

#kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# set git
echo "Please enter your name for Git config:"
read -r git_name
echo "Please enter your email address for Git config:"
read -r git_email
if [[ -n "$git_name" ]] && [[ -n "$git_email" ]]; then
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
  echo "Git config has been updated successfully."
  echo "User Name: $(git config --global user.name)"
  echo "User Email: $(git config --global user.email)"
else
  echo "Error: Both name and email are required. Git config was not updated."
  exit 1
fi

# Install Hack Nerd font
sudo chmod +x ./install_nerdfont.sh && ./install_nerdfont.sh Hack

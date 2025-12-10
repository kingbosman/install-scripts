#!/bin/bash

# set flag to stop if error
set -e
  	  	
# set git variables for later settings
echo "Please enter your name for Git config:"
read -r git_name
echo "Please enter your email address for Git config:"
read -r git_email
if [[ -n "$git_name" ]] && [[ -n "$git_email" ]]; then
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
  git config --global pull.rebase true
  echo "Git config has been updated successfully."
  echo "User Name: $(git config --global user.name)"
  echo "User Email: $(git config --global user.email)"
else
  echo "Error: Both name and email are required. Git config was not updated."
  exit 1
fi


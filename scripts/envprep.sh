#!/bin/bash

# Install required Packages
sudo apt update
sudo apt upgrade
sudo apt install zsh
sudo apt install wget
sudo apt install neofetch
sudo apt install hollywood

# Install Oh-My-ZSH
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Create Required Folders
sudo mkdir /docker /docker/tmp

# Clone the Repository and delete not required folders
sudo git clone https://github.com/J4nis05/docker-teddy.git /docker/tmp
sudo rm -rf /docker/tmp/.git /docker/tmp/diagram /docker/tmp/stacks/ImageList.yml

# Copy the Content from the Repo to their required Path
sudo cp -r /docker/tmp/stacks /docker
sudo cp /docker/tmp/scripts/compose.sh /compose.sh
sudo cp /docker/tmp/scripts/.zshrc ~/.zshrc

# Make the compose script executable
chmod +x /compose.sh

# Start The Core Services
/compose.sh -u stack-services

# Remove the Repository
sudo rm -rf /docker/tmp
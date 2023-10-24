#!/bin/bash

# Full Install Script for the Lazy People 
echo "Updating And Installing dependancies"
sudo apt update && sudo apt upgrade
sudo apt install zsh wget neofetch hollywood

# Remove Any Pre Existing Docker Apps, Images and general configuration
echo "Removing old Docker Confgiuration"
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Add Docker's official GPG key:
echo "Installing Docker Daemon and Plug-Ins"
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up Docker's APT repository:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/raspbian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install The Latest Version of Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install Oh-My-ZSH
echo "Installing Oh-My-ZSH"
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Create Required Folders
echo "Preparing Environment"
sudo mkdir /docker /docker/tmp

# Clone the Repository and delete not required folders
echo "Cloning Repository"
sudo git clone https://github.com/J4nis05/docker-teddy.git /docker/tmp
sudo rm -rf /docker/tmp/.git /docker/tmp/diagram /docker/tmp/stacks/ImageList.yml

# Copy the Content from the Repo to their required Path
echo "Copying Stacks to /docker"
sudo cp -r /docker/tmp/stacks/* /docker
echo "Copying Compose Script to /"
sudo cp /docker/tmp/scripts/compose.sh /compose.sh
echo "Copying ZSH Config to ~/"
sudo cp /docker/tmp/scripts/.zshrc ~/.zshrc

# Make the compose script executable
chmod +x /compose.sh

# Start The Core Services
echo "Starting Services: Portainer, Watchtower, Nginx, OpenVPN"
/compose.sh -u stack-services

# Remove the Repository
echo "Removing /docker/tmp"
sudo rm -rf /docker/tmp

clear

echo "Finished. Consider Restarting ZSH to Apply the New Configuration."

neofetch
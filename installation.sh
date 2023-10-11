#!/bin/bash

# Prompt the user for version choice
echo "Do you want to install a specific Docker version or the latest version?"
select choice in "Specific Version" "Latest Version"; do
  case $choice in
    "Specific Version")
      # List the available versions
      echo "Available Docker versions:"
      apt-cache madison docker-ce | awk '{ print $3 }'

      read -p "Enter the specific version (e.g., 20.04.0): " specific_version

      # Install the chosen specific version
      sudo apt-get install docker-ce=$specific_version docker-ce-cli=$specific_version containerd.io docker-buildx-plugin docker-compose-plugin
      break
      ;;
    "Latest Version")
      # Add Docker's official GPG key:
      sudo apt-get update
      sudo apt-get install -y ca-certificates curl gnupg
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg

      # Add the repository to Apt sources with the latest version:
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update

      # Install Docker packages based on the latest version:
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      break
      ;;
    *)
      echo "Invalid choice. Please select 1 for Specific Version or 2 for Latest Version."
      ;;
  esac
done

# Optionally, you can start and enable the Docker service:
# sudo systemctl start docker
# sudo systemctl enable docker

# You may also want to add your user to the docker group to run Docker without sudo:
# sudo usermod -aG docker $USER

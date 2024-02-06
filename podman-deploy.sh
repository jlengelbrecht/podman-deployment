#!/bin/sh

set -o errexit
set -o nounset
IFS=$(printf '\n\t')

# Install prerequisites
apt update -y
apt install -y sudo wget curl

# Podman
echo "Installing Podman..."
. /etc/os-release
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_${VERSION_ID}/Release.key -O- | sudo apt-key add -
sudo apt update -y
sudo apt install -y podman

printf '\nPodman installed successfully\n\n'

# Docker Compose with Podman
echo "Installing Docker Compose..."
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

printf '\nConfiguring Docker Compose to use Podman...\n\n'
sudo curl -L "https://raw.githubusercontent.com/containers/podman-compose/devel/podman_compose.py" -o /usr/local/bin/podman-compose
sudo chmod +x /usr/local/bin/podman-compose

# Optionally, create symbolic link if you want docker-compose to use podman-compose
sudo ln -sf /usr/local/bin/podman-compose /usr/local/bin/docker-compose

printf '\nDocker Compose configured to use Podman successfully\n\n'
podman --version
docker-compose --version

printf "Reminder: The 'docker-compose' commands are now configured to run as 'podman-compose' commands due to the symbolic link creation. If this behavior is not desired, remove the symbolic link.\n"

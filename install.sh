#!/usr/bin/bash

#Check root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#Unistall unofficial Docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do  apt-get -yqq remove $pkg; done

# Add Docker's official GPG key:
 apt-get update
 apt-get install ca-certificates curl
 install -m 0755 -d /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
 chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

#Install Docker + dependencies
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin python3 wget

#Checking that Docker is installed successfully
export docker_output=$(docker run hello-world)
export installed=$'Hello from Docker!\nThis message shows that your installation appears to be working correctly.'

if [[ $docker_output != *$installed* ]]; then
  echo "Docker is broken, or you don't have internet connection"
  exit $?
fi

docker run hello-world
echo "Docker is working properly"
echo "Installing manager..."
wget "https://github.com/GeoNew2011/Docker-container-manager/releases/download/v1.0/scripts.tar.gz" -o scripts.tar.gz
mkdir /usr/share/dockerManager
tar -xzf scripts.tar.gz -C /usr/share/dockerManager
chmod -R u+x /usr/share/dockerManager
mv /usr/share/dockerManager/manage $HOME
echo "Run ./manage to start manager"

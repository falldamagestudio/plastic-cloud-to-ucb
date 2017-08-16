#!/bin/sh

# Install Docker CE on an Ubuntu system


# Install Docker daemon

sudo apt-get -y update

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get -y update

sudo apt-get -y install docker-ce


# Install docker-compose

dockerComposeVersion="1.15.0"

sudo sh -c 'sudo curl -L https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod ugo+x /usr/local/bin/docker-compose'


# Give current user permission to invoke Docker

sudo groupadd -aG docker "$USER"

#!/bin/sh

# Ensure config files are available
# TODO: also test for existence of *.key files
if test ! -e "cryptedservers.conf"; then
  echo "You need to manually fetch cryptedservers.conf and associated .key files from your Plastic Server installation folder and place them in your current dir, before running this script"
  exit 1
fi

# Set up "git" user SSH account
ssh-keygen -t rsa -N "" -f id_rsa.plastic
docker cp id_rsa.plastic.pub git-server:/git-server/keys

# Set up encryption for Plastic server when talking to Plastic Cloud repositories
docker cp cryptedservers.conf plastic:/conf
docker cp *.key plastic:/conf
docker exec plastic sed -i 's/ / \/conf\//g' /conf/cryptedservers.conf # Make file paths inside of cryptedservers.conf that reference key files absolute

# Enable plastic container to talk to Git via SSH
docker cp id_rsa.plastic plastic:/conf

docker-compose restart

#!/bin/sh

if test ! -e "client.conf"; then
  echo "You need to manually fetch client.conf from the Plastic user-local files folder (typically C:\Users\<username>\AppData\Local\plastic4) and place it in your current dir, before running this script"
  exit 1
fi

# Ensure config files are available
# TODO: also test for existence of *.key files
if test ! -e "cryptedservers.conf"; then
  echo "You need to manually fetch cryptedservers.conf and associated .key files from your Plastic Server installation folder and place them in your current dir, before running this script"
  exit 1
fi

# Create authentication file for when the local Plastic server is going to connect to Plastic Cloud
echo "LDAPWorkingMode" > authentication.conf
grep -E -m 1 -o "<SecurityConfig>(.*)</SecurityConfig>" client.conf | sed -e 's,.*<SecurityConfig>\([^<]*\)</SecurityConfig>.*,\1,g' >> authentication.conf
docker cp authentication.conf plastic:/conf

# Set up "git" user SSH account
if test ! -e id_rsa; then
  ssh-keygen -t rsa -N "" -f id_rsa
fi
docker cp id_rsa.pub git-server:/git-server/keys

# Set up encryption for Plastic server when talking to Plastic Cloud repositories
docker cp cryptedservers.conf plastic:/conf
docker cp *.key plastic:/conf
docker exec plastic sed -i 's/ / \/conf\//g' /conf/cryptedservers.conf # Make file paths inside of cryptedservers.conf that reference key files absolute

# Enable plastic container to talk to Git via SSH
docker cp id_rsa plastic:/conf

docker-compose restart

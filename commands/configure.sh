#!/bin/sh

if test ! -e "temp/profiles.conf"; then
  echo "You need to manually fetch profiles.conf from the Plastic user-local files folder (typically C:\Users\<username>\AppData\Local\plastic4) and place it in temp/, before running this script"
  exit 1
fi

# Ensure config files are available
# TODO: also test for existence of *.key files
if test ! -e "temp/cryptedservers.conf"; then
  echo "You need to manually fetch cryptedservers.conf and associated .key files from your Plastic Server installation folder and place them in temp/, before running this script"
  exit 1
fi

# Create authentication file for when the local Plastic server is going to connect to Plastic Cloud
echo "LDAPWorkingMode" > temp/authentication.conf
grep -E -m 1 -o "<SecurityConfig>(.*)</SecurityConfig>" temp/profiles.conf | sed -e 's,.*<SecurityConfig>\([^<]*\)</SecurityConfig>.*,\1,g' >> temp/authentication.conf
docker cp temp/authentication.conf plastic:/conf

# Determine remote server name for when the local Plastic server is going to connect to Plastic Cloud
grep -E -m 1 -o "<Server>(.*)</Server>" temp/profiles.conf | sed -e 's,.*<Server>\([^<]*\)</Server>.*,\1,g' > temp/remote_server.conf
docker cp temp/remote_server.conf plastic:/conf

# Set up "git" user SSH account
if test ! -e temp/id_rsa; then
  ssh-keygen -t rsa -N "" -f temp/id_rsa
fi
docker cp temp/id_rsa.pub git-server:/git-server/keys

# Set up encryption for Plastic server when talking to Plastic Cloud repositories
docker cp temp/cryptedservers.conf plastic:/conf
docker cp temp/*.key plastic:/conf
docker exec plastic sed -i 's/ / \/conf\//g' /conf/cryptedservers.conf # Make file paths inside of cryptedservers.conf that reference key files absolute

# Enable plastic container to talk to Git via SSH
docker cp temp/id_rsa plastic:/conf

docker-compose restart

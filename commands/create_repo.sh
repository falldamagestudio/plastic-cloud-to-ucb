#!/bin/sh

if [ $# -lt 1 ]; then
  echo "Usage: create_repo <reponame>"
  exit 1
fi

reponame="$1"

docker exec plastic /root/initrepo.sh "$reponame"
echo "Repository is available at ssh://git@`docker-machine ip`:2222/repos/""$reponame"".git"
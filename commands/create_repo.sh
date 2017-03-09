#!/bin/sh

if [ $# -lt 1 ]; then
  echo "Usage: create_repo <reponame>"
  exit 1
fi

docker exec plastic /root/initrepo $1

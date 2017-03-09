#!/bin/sh

if [ $# -lt 1 ]; then
  echo "Usage: destroy_repo <reponame>"
  exit 1
fi

docker exec plastic /root/rmrepo.sh $1

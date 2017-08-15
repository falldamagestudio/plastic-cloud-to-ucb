#!/bin/sh

if [ $# -lt 1 ]; then
  echo "Usage: replicate <reponame>"
  exit 1
fi

docker exec plastic /root/replicate.sh $1

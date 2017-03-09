#!/bin/sh

if [ $# -lt 2 ]; then
  echo "Usage: replicate <reponame> <organization>"
  exit 1
fi

docker exec plastic /root/replicate.sh $1 $2

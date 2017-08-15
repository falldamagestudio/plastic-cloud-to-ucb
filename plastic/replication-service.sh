#!/bin/sh

# Interval between each full replication pass
interval=60

replicate() {
  for repository_name in `cm lrep --format="{repname}" | grep -v "default"`
  do
    /root/replicate.sh "$repository_name"
  done
}

while :
do
  echo "Beginning replication"
  replicate
  echo "Waiting $interval seconds for next replication..."
  sleep "$interval"
done
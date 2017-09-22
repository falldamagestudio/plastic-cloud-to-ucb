#!/bin/sh

# Interval between each full replication pass
interval=60

while :
do
  echo "Beginning replication"
  replicate.sh
  echo "Waiting $interval seconds for next replication..."
  sleep "$interval"
done

#!/bin/sh

# Interval between each full replication pass
interval=60

while :
do
  echo "Beginning replication"
  /root/replicate.sh
  echo "Waiting $interval seconds for next replication..."
  sleep "$interval"
done

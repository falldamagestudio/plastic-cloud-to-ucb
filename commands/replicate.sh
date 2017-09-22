#!/bin/sh

echo "Updating all branches in all repositories in local Plastic server, replicating Plastic Cloud -> local Plastic server -> local Git server"
docker exec plastic /root/replicate.sh
echo "Done"

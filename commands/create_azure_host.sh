#!/bin/sh

# This script sets up a VM for you in Azure.
# You will need to provide your Azure subscription ID.
#
# The VM will have Docker installed on it, and port 2222 will be opened (this is where the Git server will be accessible).

if [ $# -lt 1 ]; then
  echo "Usage: create_azure_host <Azure subscription ID> <location [default: northeurope]>"
  exit 1
fi

id="$1"

location=northeurope
if [ $# -ge 2 ]; then
  location="$2"
fi

name=plastic-cloud-to-ucb-azure

docker-machine create --driver azure --azure-subscription-id "$id" --azure-resource-group "$name" --azure-availability-set "$name" --azure-ssh-user ops --azure-open-port 2222 --azure-location "$location" --azure-vnet "$name" --azure-subnet "$name" --azure-static-public-ip "$name"

#!/bin/bash

# This script sets up a VM for you in Google Cloud.
# You will need to provide the ID of a Google Cloud project which you have created.
#
# You may have to log in & set up credentials first:
# gcloud[.cmd] auth login
# gcloud[.cmd] auth application-default login
#
# You have to create a project in Google Cloud first, with name "Plastic Cloud to UCB GCE", enable Cloud Engine API access, and set up billing.
#
# The VM will have Docker installed on it, and port 2222 will be opened (this is where the Git server will be accessible).

set -eu

#if [ $# -lt 0 ]; then
#  echo "Usage: create_host.sh <region [default: europe-west1]> <zone [default: europe-west1-b]>"
#  exit 1
#fi 

projectname="Plastic Cloud to UCB GCE"

name="plastic-cloud-to-ucb-gce"

region=europe-west1
if [ $# -ge 1 ]; then
  region="$1"
fi

zone=europe-west1-b
if [ $# -ge 2 ]; then
  zone="$2"
fi

gcloud=`./commands/gce/gcloud.sh`

# Translate from  project name to project ID
projectid=`"$gcloud" projects list | grep "$projectname" | awk '{ print $1 }'`
if [ "$projectid" == "" ]; then
  echo "Project \"$projectname\" cannot be found in Google Cloud. Please make sure you have created the project, enabled Compute Engine API access, and configured billing."
  exit 1
fi

# Switch currently-active project to this one
"$gcloud" config set project "$projectid"

# Allocate a static IP address
"$gcloud" compute addresses create --project "$projectid" --region "$region" "$name"

# Start VM, connect it to static IP address
docker-machine create --driver google \
	--google-project "$projectid" \
	--google-zone "$zone" \
	--google-machine-type g1-small \
	--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1404-lts \
	--google-disk-size 100 \
	--google-address "$name" \
	$name

# Open up port 2222 for external access
"$gcloud" compute firewall-rules create --project "$projectid" --allow tcp:2222 "$name"

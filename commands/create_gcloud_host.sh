#!/bin/bash

# This script sets up a VM for you in Google Cloud.
# You will need to provide the ID of a Google Cloud project which you have created.
#
# You may have to log in & set up credentials first:
# gcloud[.cmd] auth login
# gcloud[.cmd] auth application-default login
#
# The VM will have Docker installed on it, and port 2222 will be opened (this is where the Git server will be accessible).

if [ $# -lt 1 ]; then
  echo "Usage: create_google_host <Google Cloud Project ID> <region [default: europe-west1]> <zone [default: europe-west1-b]>"
  exit 1
fi 
google_cloud_project_id="$1"

name=plastic-cloud-to-ucb-gcloud

region=europe-west1
if [ $# -ge 2 ]; then
  region="$2"
fi

zone=europe-west1-b
if [ $# -ge 3 ]; then
  zone="$3"
fi

# The Docker Bash terminal under Windows will not match 'gcloud' against 'gcloud.cmd'. Therefore we will try both gcloud and gcloud.cmd. 
gcloud=gcloud
if ! type "$gcloud" &> /dev/null; then
  gcloud=gcloud.cmd
  if ! type "$gcloud" &> /dev/null; then
    echo "Cannot run 'gcloud' commands. Please ensure you have installed the Google Cloud SDK and added the gcloud binaries directory to your PATH."
    exit 1
  fi
fi


# Allocate a static IP address
"$gcloud" compute addresses create --region "$region" "$name"

## Set up a new service account and create application credentials for it
#export GOOGLE_APPLICATION_CREDENTIALS=temp/google_application_credentials.json
#"$gcloud" iam service-accounts create --display-name "$name" "$name"
#iam_account=`"$gcloud" iam service-accounts list | grep "$name" | awk '{ print $2 }'`
#"$gcloud" iam service-accounts keys create --iam-account "$iam_account" "$GOOGLE_APPLICATION_CREDENTIALS"

# Start VM, connect it to static IP address
docker-machine create --driver google \
	--google-project "$google_cloud_project_id" \
	--google-zone "$zone" \
	--google-machine-type g1-small \
	--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1404-lts \
	--google-disk-size 100 \
	--google-address "$name" \
	$name

# Open up port 2222 for external access
"$gcloud" compute firewall-rules create --allow tcp:2222 "$name"

#!/bin/bash

# This script removes your Google Cloud VM.
#
# You may have to log in & set up credentials first:
# gcloud[.cmd] auth login
# gcloud[.cmd] auth application-default login

# The Docker Bash terminal under Windows will not match 'gcloud' against 'gcloud.cmd'. Therefore we will try both gcloud and gcloud.cmd. 
gcloud=gcloud
if ! type "$gcloud" &> /dev/null; then
  gcloud=gcloud.cmd
  if ! type "$gcloud" &> /dev/null; then
    echo "Cannot run 'gcloud' commands. Please ensure you have installed the Google Cloud SDK and added the gcloud binaries directory to your PATH."
    exit 1
  fi
fi

name=plastic-cloud-to-ucb-gcloud

region="europe-west1"

# Remove VM
docker-machine rm "$name"

# Remove firewall rule
"$gcloud" compute firewall-rules delete "$name"

# Deallocate static IP address
"$gcloud" compute addresses delete --region "$region" "$name"

## Determimne account name in email address form
#iam_account=`"$gcloud" iam service-accounts list | grep "$name" | awk '{ print $2 }'`
#
## Delete service account
#"$gcloud" iam service-accounts delete "$iam_account"

#!/bin/bash

# This script removes your Google Cloud VM.
#
# You may have to log in & set up credentials first:
# gcloud[.cmd] auth login
# gcloud[.cmd] auth application-default login

gcloud=`./commands/gce/gcloud.sh`

name=plastic-cloud-to-ucb-gce

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

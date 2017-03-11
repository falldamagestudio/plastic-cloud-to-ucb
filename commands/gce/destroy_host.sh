#!/bin/bash

# This script removes your Google Cloud VM.
#
# You may have to log in & set up credentials first:
# gcloud[.cmd] auth login
# gcloud[.cmd] auth application-default login

set -eu

gcloud=`./commands/gce/gcloud.sh`

name=plastic-cloud-to-ucb-gce

# Remove VM
docker-machine rm "$name"

# Remove firewall rule
"$gcloud" compute firewall-rules delete --quiet "$name"

# Deallocate static IP address
for region in `"$gcloud" compute addresses list | grep "$name" | awk '{ print $2 }'`; do
  "$gcloud" compute addresses delete --quiet --region "$region" "$name"
done

## Determimne account name in email address form
#iam_account=`"$gcloud" iam service-accounts list | grep "$name" | awk '{ print $2 }'`
#
## Delete service account
#"$gcloud" iam service-accounts delete --quiet "$iam_account"

#!/bin/bash

# This script removes your Google Cloud VM.
#
# You may have to log in & set up credentials first:
# gcloud[.cmd] auth login
# gcloud[.cmd] auth application-default login

# Run all cleanup steps, even if one fails
#set -eu

gcloud=`./commands/gce/gcloud.sh`

projectname="Plastic Cloud to UCB GCE"

name="plastic-cloud-to-ucb-gce"

# Translate from  project name to project ID
projectid=`"$gcloud" projects list | grep "$projectname" | awk '{ print $1 }'`
if [ "$projectid" == "" ]; then
  echo "Project \"$projectname\" cannot be found in Google Cloud. Please make sure you have created the project, enabled Compute Engine API access, and configured billing."
  exit 1
fi

# Switch currently-active project to this one
"$gcloud" config set project "$projectid"

# Remove VM
"$gcloud" compute instances delete --quiet "$name"

# Remove firewall rule
"$gcloud" compute firewall-rules delete --quiet "$name"

# Deallocate static IP address
for region in `"$gcloud" compute addresses list | grep "$name" | awk '{ print $2 }'`; do
  "$gcloud" compute addresses delete --quiet --region "$region" "$name"
done

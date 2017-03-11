#!/bin/bash

set -eu

# The Docker Bash terminal under Windows will not match 'gcloud' against 'gcloud.cmd'. Therefore we will try both gcloud and gcloud.cmd. 

if command -v "gcloud" > /dev/null 2>&1; then
  echo "gcloud"
  exit 0
elif command -v "gcloud.cmd" > /dev/null 2>&1; then
  echo "gcloud.cmd"
  exit 0
else
  >&2 echo "Cannot run 'gcloud' commands. Please ensure you have installed the Google Cloud SDK and added the gcloud binaries directory to your PATH."
  exit 1
fi

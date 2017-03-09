#!/bin/sh

# This script removes your Azure VM.

docker-machine stop plastic-cloud-to-ucb
docker-machine rm plastic-cloud-to-ucb

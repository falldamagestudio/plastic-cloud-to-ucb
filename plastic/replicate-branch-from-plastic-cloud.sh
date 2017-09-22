#!/bin/sh

# Replicate one branch from a repository in Plastic Cloud, to local Plastic server

if [ "$#" -ne 2 ]
then

	# Display usage and stop
	echo "Usage: replicate-branch-from-plastic-cloud.sh <reponame> <branchname>"
	exit 1

fi 

repo_name="$1"
source_replication_branch="$2"

remote_server=`cat /conf/remote_server.conf`

source_replication_path="$source_replication_branch"@"$repo_name"@"$remote_server"
local_repository_name="$repo_name"
git_repository_url=git@git-server:repos/"$repo_name".git

# Replicate from Plastic Cloud to local Plastic server
echo "Replicating from $source_replication_path to $local_repository_name in local Plastic server"
cm replicate "$source_replication_path" "$local_repository_name" --authfile=/conf/authentication.conf

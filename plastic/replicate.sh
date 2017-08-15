#!/bin/sh

# Replicate /main branch from repository in Plastic Cloud, to local Plastic server, and further on to local Git server

if [ "$#" -ne 1 ]
then

	# Display usage and stop
	echo "Usage: replicate <reponame>"
	exit 1

fi 

repo_name="$1"

# Only replicate /main branch from Plastic Cloud
source_replication_branch=/main

remote_server=`cat /conf/remote_server.conf`

source_replication_path="$source_replication_branch"@"$repo_name"@"$remote_server"
local_repository_name="$repo_name"
git_repository_url=git@git-server:repos/"$repo_name".git

# Replicate from Plastic Cloud to local Plastic server
echo "Replicating from $source_replication_path to $local_repository_name in local Plastic server"
cm replicate "$source_replication_path" "$local_repository_name" --authfile=/conf/authentication.conf

# Replicate from local Plastic server to local Git server
echo "Replicating from $local_repository_name in local Plastic server to $git_repository_url"
cm sync "$local_repository_name" git "$git_repository_url"

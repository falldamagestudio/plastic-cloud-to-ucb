#!/bin/sh

# Replicate a repository in local Plastic server to local Git server

if [ "$#" -ne 1 ]
then

	# Display usage and stop
	echo "Usage: replicate-repo-to-local-git-server.sh <reponame>"
	exit 1

fi 

repo_name="$1"

local_repository_name="$repo_name"
git_repository_url=git@git-server:repos/"$repo_name".git

# Replicate from local Plastic server to local Git server
echo "Replicating from $local_repository_name in local Plastic server to $git_repository_url"
cm sync "$local_repository_name" git "$git_repository_url"

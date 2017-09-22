#!/bin/sh

# Replicate all branches in all repositories in the local Plastic server, Plastic Cloud -> local Plastic server -> local Git server

for repository_name in `cm lrep --format="{repname}" | grep -v "default"`
do
	cm find "branches on repository '$repository_name'" --nototal --format="{name}" | while IFS= read -r branch_name
	do
		/root/replicate-branch-from-plastic-cloud.sh "$repository_name" "$branch_name"
	done

	/root/replicate-repo-to-local-git-server.sh "$repository_name"
done

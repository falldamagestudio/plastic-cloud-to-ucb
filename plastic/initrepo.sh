#!/bin/sh

# Create repositories in local Plastic and Git servers

if [ "$#" -ne 1 ]
then

	# Display usage and stop
	echo "Usage: initrepo <reponame>"
	exit 1

fi 

cm mkrep $1
ssh git@git-server initrepo $1

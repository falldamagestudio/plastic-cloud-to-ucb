#!/bin/sh

# Delete repository in local Plastic and Git servers

if [ "$#" -ne 1 ]
then

	# Display usage and stop
	echo "Usage: rmrepo <reponame>"
	exit 1

fi 

cm rmrep $1
ssh git@git-server rmrepo $1

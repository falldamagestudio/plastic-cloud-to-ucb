#!/bin/sh

# Replicate /main branch from repository in Plastic Cloud, to local Plastic server, and further on to local Git server

if [ "$#" -ne 2 ]
then

	# Display usage and stop
	echo "Usage: replicate <reponame> <organization>"
	exit 1

fi 

cm replicate /main@$1@$2@Cloud $1
cm sync $1 git git@git-server:repos/$1.git

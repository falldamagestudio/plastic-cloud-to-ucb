# Bridge from Plastic Cloud to Unity Cloud Build

Glue logic which enables Unity Cloud Build to build from Plastic Cloud repositories. This is accomplished by running some bridge repositories on a machine in the Azure cloud.

## Current state

It works, but it does not replicate automatically. Replication needs to be triggered manually each time.

## Overview

This package contains two Docker containers. Together, these form a bridge from Plastic Cloud to Unity Cloud Build.

1. Plastic server/client. This will replicate from repos in Plastic Cloud, and push to Git server. Originally based on https://github.com/kalmalyzer/plastic-docker image.
2. Git server. Originally based on https://hub.docker.com/r/jkarlos/git-server-docker

The containers can be run on the same VM.

## Prerequisites
- Install [Docker](https://docs.docker.com/engine/installation/) or [Docker Toolbox](https://docs.docker.com/toolbox/overview/)
- Install [Python 2.x or 3.x](https://www.python.org/downloads/)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## "Quick" start

Perform all activity from within the Docker terminal

### Rent & start up a VM in Azure

	commands/create_azure_host.sh
	
### Build Docker containers

	commands/build.sh

### Start Docker containers

	commands/up.sh

### Configure Docker containers to talk to each other and Plastic Cloud

	Copy cryptedservers.conf & *.key files from the PlasticSCM5\server directory on your local machine to current working dir
	commands/configure.sh

### Configure Docker container to accept logins from Unity Cloud Build

	Begin setup of the build job in Unity Cloud Build; URL = ssh://git@<Azure machine IP>:2222/git-server/repos/<reponame>.git
	Copy the SSH public key that will be used into a file named 'id_rsa.ucb.pub'
	commands/configure.sh

### Prepare for replication of a Plastic Cloud repository

	commands/create_repo.sh <reponame>
	
### Replicate repository from Plastic Cloud to the Git server running inside the VM

	commands/replicate.sh <reponame> <Plastic Cloud organization>
		[enter username & password for Plastic Cloud account]

### Trigger build in Unity Cloud Build

	Done! UCB should now be able to fetch contents from the Git repository and build it

### Remove repository from Git server

	commands/remove_repo.sh <reponame>
	
### Remove VM from Azure

	commands/destroy_azure_host.sh

## Misc
	
### Configure Docker tools to work against local Docker VM

	eval $(docker-machine env default)

### Configure Docker tools to work against the VM in Azure

	eval $(docker-machine env plastic-cloud-to-ucb)

	
## Thanks

Thanks to Miguel González for the original Plastic server project: https://github.com/mig42/plastic-docker
Thanks to José Carlos Bernárdez for the original Git server project: https://github.com/jkarlosb/git-server-docker

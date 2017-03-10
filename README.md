# Bridge from Plastic Cloud to Unity Cloud Build

Glue logic which enables Unity Cloud Build to build from Plastic Cloud repositories. This is accomplished by running some bridge repositories on a machine in the Azure cloud.

## Current state

It works, but it does not replicate automatically. Replication needs to be triggered manually each time.

## Overview

This package contains two Docker containers. Together, these form a bridge from Plastic Cloud to Unity Cloud Build.

1. Plastic server/client. This will replicate from repos in Plastic Cloud, and push to the Git server.
2. Git server. This will be exposed to the Internet. Unity Cloud Build will regularly look for changes in this server.

The containers can be run on the same VM.

## Prerequisites

- Install [Plastic Cloud Edition](https://www.plasticscm.com/download/)
  - Have an organization set up in Plastic Cloud
  - Have at least one repo created in your organization's Plastic Cloud account
  - Have your local Plastic client/server able to connect to the Plastic Cloud account
  - Have a connection profile configured with account credentials for accessing your organization's Plastic Cloud account
- Install [Docker](https://docs.docker.com/engine/installation/) or [Docker Toolbox](https://docs.docker.com/toolbox/overview/)
- Install [Python 2.x or 3.x](https://www.python.org/downloads/)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## "Quick" start

Perform all activity from within the Docker terminal

### Rent & start up a VM in Azure

Run `commands/create_azure_host.sh`

### Build Docker containers

Run `commands/build.sh`

### Start Docker containers

Run `commands/up.sh`

### Configure Docker containers to talk to each other and Plastic Cloud

Copy cryptedservers.conf & *.key files from `C:\Program Files\PlasticSCM5\server` to `temp`
Copy profiles.conf from `C:\Users\<Current user>\AppData\Local\plastic4` to `temp`
Run `commands/configure.sh`

### Configure Docker container to accept logins from Unity Cloud Build

Begin setup of the build job in Unity Cloud Build; URL = `ssh://git@<Azure machine IP>:2222/repos/<reponame>.git`
Copy the SSH public key that Unity Cloud Build will use into a file named `temp/id_rsa.ucb.pub`
Run `commands/configure.sh`

### Prepare for replication of a Plastic Cloud repository

Run `commands/create_repo.sh <reponame>`

### Replicate repository from Plastic Cloud to the Git server running inside the VM

Run `commands/replicate.sh <reponame>`

### Trigger build in Unity Cloud Build

Done! UCB should now be able to fetch contents from the Git repository and build it

### Remove repository from Git server

Run `commands/remove_repo.sh <reponame>`

### Remove VM from Azure

Run `commands/destroy_azure_host.sh`

## Misc
	
### Configure Docker tools to work against local Docker VM

Run `eval $(docker-machine env default)`

### Configure Docker tools to work against the VM in Azure

Run `eval $(docker-machine env plastic-cloud-to-ucb-azure)`

	
## Thanks

Thanks to Miguel González for the original Plastic server project: https://github.com/mig42/plastic-docker
Thanks to José Carlos Bernárdez for the original Git server project: https://github.com/jkarlosb/git-server-docker

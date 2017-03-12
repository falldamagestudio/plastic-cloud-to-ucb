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

## "Quick" start

Perform all activity from within the Docker terminal

### Build Docker containers

Run `commands/build.sh`

### Start Docker containers

Run `commands/up.sh`

### Configure Docker containers to talk to each other and Plastic Cloud

Copy cryptedservers.conf & *.key files from `C:\Program Files\PlasticSCM5\server` to `temp`
Copy profiles.conf from `C:\Users\<Current user>\AppData\Local\plastic4` to `temp`
Run `commands/configure.sh`

### Prepare for replication of a Plastic Cloud repository

Run `commands/create_repo.sh <reponame>`

### Replicate repository from Plastic Cloud to the Git server running inside the VM

Run `commands/replicate.sh <reponame>`

### Configure Docker container to accept logins from Unity Cloud Build for one specific project

Begin setup of the build job in Unity Cloud Build; URL = `ssh://git@<Azure machine IP>:2222/repos/<reponame>.git`
Copy the SSH public key that Unity Cloud Build will use into a file named `temp/id_rsa.<reponame>.pub`
Run `commands/configure.sh`

### Trigger build in Unity Cloud Build

(This requires the host that runs Docker to be accessible from the Internet)

Done! UCB should now be able to fetch contents from the Git repository and build it

### Remove repository from Git server

Run `commands/remove_repo.sh <reponame>`

## Microsoft Azure

### Prerequisites

- Install [Python 2.x or 3.x](https://www.python.org/downloads/)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

### Authentication

Run `az login` and complete authentication in browser

### Rent & start up a VM in Azure

Run `commands/azure/create_host.sh`

### Configure Docker tools to work against your VM in Azure

Run `eval $(docker-machine env plastic-cloud-to-ucb-azure)`

### Remove your VM from Azure

Run `commands/azure/destroy_host.sh`

## Google Cloud / Google Compute Engine

### Prerequisites

- Install [Google Cloud SDK](https://cloud.google.com/sdk/downloads)
- Create a new project in Google cloud
  - Name it "Plastic Cloud to UCB GCE"
  - Enable Compute Engine API access for project
  - Enable billing for project

### Authentication

Run `gcloud auth login` and complete authentication in browser

Run `gcloud auth application-default login` and complete authentication in browser

### Rent & start up a VM with Google Compute Engine

Run `./commands/gce/create_host.sh [region (default: europe-west1)] [zone (default: europe-west1-b)]`

### Configure Docker tools to work against your VM in Google Compute Engine

Run `eval $(docker-machine env plastic-cloud-to-ucb-gce)`

### Remove your VM from Google Compute Engine

Run `./commands/gce/destroy_host.sh`
   
## Misc
	
### Configure Docker tools to work against local Docker VM

Run `eval $(docker-machine env default)`

	
## Thanks

Thanks to Miguel González for the original Plastic server project: https://github.com/mig42/plastic-docker
Thanks to José Carlos Bernárdez for the original Git server project: https://github.com/jkarlosb/git-server-docker

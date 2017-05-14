﻿# Bridge from Plastic Cloud to Unity Cloud Build

Glue logic which enables [Unity Cloud Build](https://unity3d.com/services/cloud-build) to build from [Plastic Cloud](https://www.plasticscm.com/cloud/index.html) repositories.

If either of these happened, this project would become obsolete:

1. Codice Software implements a Git server interface, complete with account- and SSH-key-authentication, for Plastic Cloud. Once there is such an interface, then Unity Cloud Build will be able to connect to the Plastic Cloud repositories with their current implementation. [Forum thread](http://www.plasticscm.net/index.php?/topic/20148-does-plastic-support-unity-cloud-build-yet/)
2. Unity's Cloud Build team implements Plastic-specific tooling or protocol support that enables it to watch and pull from remote Plastic repositories. [Forum thread](https://forum.unity3d.com/threads/plastic-scm-support-in-ucb.268999/)

## Current state

This is used for our internal development now.

## Overview

![Plastic cloud to UCB diagram](https://www.draw.io/?lightbox=1&highlight=0000ff&nav=1&title=Plastic%20Cloud%20to%20UCB#R3Zhdb5swFIZ%2FDbcTYCDpZZN17cUmVYqmdZcuOGDV2MiYJtmv3wFsvky2LGsTqbkBH38%2F7%2FE5Dg5a5%2Ft7iYvsm0gIc3w32Tvos%2BP7nhv48Kgth9YSumFrSCVNdKPesKG%2FiOmprRVNSDlqqIRgihZjYyw4J7Ea2bCUYjduthVsPGuBU2IZNjFmtvUHTVTWWpeh29sfCE0zM7Pn6ppnHL%2BkUlRcz%2Bf4aNv82uocm7F0%2BzLDidgNTOjOQWsphGrf8v2asJqtwdb2%2B3Kktlu3JFyd0gG1HV4xq%2FTWv3OqDmBaM1El8FxVFOC1i1UHA2iXUUU2BY7r8g6cwEGrTOUMSh686lGJVGR%2FdGVet1%2FwIyJyomQ9selwoxFpF%2FKRLu96QTyDMRuIEWkb1j6QdkP3HOBFo5jHElhYHhkuFY17MBcHEkRXBBJaQP6VwJYythZMyKY1SjBZbmOwl0qKFzKoieIled6%2BkRMtxsxQZDML0Ayz7kD%2FD7TIgvZVQIwB0z1Vjh8xVe%2B%2FwBzeU9XsOMJ5zY0%2Fl%2FWjJBK2b1rCdOPGVz%2BTaHlBF1wcpdmfTQPs6ofzomS8E04n4cltnRihFAOuksZjBrBPeXiCgvspNMWfpm5P1aAKSnWN25EjiZVNJ9xgKaKSMRmdC4VlStQgD9l0B%2FTCGXjGJgnDir6OFzFHVM%2FwKCgsrxPPn7p1MBGlXbzuNcymk4HCaYj2JgO1W7YGagTutn2a5nZwOV9zb6h4r%2FKTVrlTvKk5T%2FOFrXl0Tc2t68VUqlM1R%2F7EeW7eT3M7BPahD1LK5sBjywkgpqmx7OOMywUnk%2FSsTZjRlNe%2BA7pCUEWrOkJSCLm3uiKnSVJPs5qLr28QVNE0e88E1WDGRfy3iKlLi3WTtN2iatqJJs%2B4m83DRyJuJXjPJh69F%2FGbP3i3JAUDEIoK%2FpF4W9eGC%2FI2Y7zHrcF1jt0avLMzSGBnkMU1M0iI%2FhL4T741TAea%2Fvc4O4NAsf%2BU0Dbvv9egu98%3D)

This package contains two Docker containers. You deploy these containers to a VM in Azure or Google Cloud. Together, these form a bridge from Plastic Cloud to Unity Cloud Build.

1. Plastic server/client. This will replicate from repos in Plastic Cloud, and push to the Git server.
2. Git server. This will be exposed to the Internet. Unity Cloud Build will regularly look for changes in this server.

## Prerequisites

- Install [Plastic Cloud Edition](https://www.plasticscm.com/download/)
  - Have an organization set up in Plastic Cloud
  - Have at least one repo created in your organization's Plastic Cloud account
  - Have your local Plastic client/server able to connect to the Plastic Cloud account
  - Have a connection profile configured with account credentials for accessing your organization's Plastic Cloud account
- Install [Docker](https://docs.docker.com/engine/installation/) or [Docker Toolbox](https://docs.docker.com/toolbox/overview/)

## "Quick" start

- Begin by [testing on your local machine](#testing-on-your-local-machine).
You should be able to get replication up and running, but Unity Cloud Build will be unable to connect since your machine does not have a public IP.
- Rent a VM from [Azure](#running-in-microsoft-azure) or [Google Cloud / Google Compute Engine](#running-in-google-cloud--google-compute-engine)
- Deploy the current configuration to Azure/Google: Run `./commands/up.sh && ./commands/configure.sh`
- Add repositories for replication:
  - Run `./commands/create_repo.sh <reponame>` for a repo
  - Run `docker exec -it /root/replicate.sh <reponame>` to perform initial replication
- Add repositories for replication:
  - Run `./commands/create_repo.sh <reponame>` for a repo
  - Configure Unity Cloud Build for the corresponding project to point to the server URL
  - Copy the SSH key from the Unity Cloud Build configuration to `./temp/id_rsa.<reponame>.pub`
  - Run `./commands/configure.sh` to add key to Git server
  - Unity Cloud Build should now be able to initiate builds from the newly added repository

## CI results for containers

See [the Docker Hub page](https://hub.docker.com/r/falldamage/plastic-cloud-to-ucb/builds/) for build status.

## Testing on your local machine

Perform all activity from within the Docker terminal.

### Build Docker containers

Run `./commands/build.sh`

### Start Docker containers

Run `./commands/up.sh`

### Configure Docker containers to talk to each other and Plastic Cloud

Copy cryptedservers.conf & *.key files from `C:\Program Files\PlasticSCM5\server` to `temp`

Copy profiles.conf from `C:\Users\<Current user>\AppData\Local\plastic4` to `temp`

Run `./commands/configure.sh`

### Prepare for replication of a Plastic Cloud repository

Run `./commands/create_repo.sh <reponame>`

### Replicate repository from Plastic Cloud to the Git server running inside the VM

Run `./commands/replicate.sh <reponame>`

### Configure Git server to accept logins from Unity Cloud Build for one specific project

Begin setup of the build job in Unity Cloud Build; URL = `ssh://git@<Docker machine external IP>:2222/repos/<reponame>.git`

Copy the SSH public key that Unity Cloud Build will use into a file named `temp/id_rsa.<reponame>.pub`

Run `./commands/configure.sh`

Unity Cloud Build should now be able to access the repository on your Git server.

### Start continuous replication

Run `./commands/start_replication_service.sh`

### Stop continuous replication

Run `./commands/stop_replication_service.sh`

### Remove repository from Git server

Run `./commands/remove_repo.sh <reponame>`

## Running in Microsoft Azure

### Prerequisites

- Install [Python 2.x or 3.x](https://www.python.org/downloads/)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

### Authentication

Run `az login` and complete authentication in browser

### Rent & start up a VM in Azure

Run `./commands/azure/create_host.sh`

### Configure Docker tools to work against your VM in Azure

Run `eval $(docker-machine env plastic-cloud-to-ucb-azure)`

### Remove your VM from Azure

Run `./commands/azure/destroy_host.sh`

## Running in Google Cloud / Google Compute Engine

### Prerequisites

- Install [Google Cloud SDK](https://cloud.google.com/sdk/downloads)
- Create a new project in Google cloud
  - Name it "Plastic Cloud to UCB GCE"
  - Enable Compute Engine API access for project
  - Enable billing for project

### Authentication

Run `eval $(./commands/gce/gcloud.sh) auth login` and complete authentication in browser

Run `eval $(./commands/gce/gcloud.sh) auth application-default login` and complete authentication in browser

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

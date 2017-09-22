# Bridge from Plastic Cloud to Unity Cloud Build

Glue logic which enables [Unity Cloud Build](https://unity3d.com/services/cloud-build) to build from [Plastic Cloud](https://www.plasticscm.com/cloud/index.html) repositories.

If either of these happened, this project would become obsolete:

1. Codice Software implements a Git server interface, complete with account- and SSH-key-authentication, for Plastic Cloud. Once there is such an interface, then Unity Cloud Build will be able to connect to the Plastic Cloud repositories with their current implementation. [Forum thread](http://www.plasticscm.net/index.php?/topic/20148-does-plastic-support-unity-cloud-build-yet/)
2. Unity's Cloud Build team implements Plastic-specific tooling or protocol support that enables it to watch and pull from remote Plastic repositories. [Forum thread](https://forum.unity3d.com/threads/plastic-scm-support-in-ucb.268999/)

## Current state

This is used for our internal development now.

## Overview

![Plastic cloud to UCB diagram](Plastic%20Cloud%20to%20UCB.png)

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
- Rent a VM from [Google Cloud / Google Compute Engine](#running-in-google-cloud--google-compute-engine)
- SSH into the VM: `eval $(./commands/gce/gcloud.sh) compute ssh plastic-cloud-to-ucb-gce`
- Clone the Git repository to your VM
- Duplicate the 'temp' directory to your VM
- Deploy the current configuration to Google: Run `./commands/up.sh && ./commands/configure.sh`
- Add repositories and branches for replication:
  - Run `./commands/create_repo.sh <reponame>` for a repo
  - Run `./commands/replicate_repo_branch.sh <reponame> <branch>` to perform initial replication for a branch in that repo
- Enable Unity Cloud Build to access repository:
  - Configure Unity Cloud Build for the corresponding project to point to the server URL
  - Copy the SSH key from the Unity Cloud Build configuration to `./temp/id_rsa.<reponame>.pub`
  - Run `./commands/configure.sh` to add key to Git server
  - Unity Cloud Build should now be able to initiate builds from the newly added repository
- Start continuous replication:
  - Run `./commands/start_replication_service.sh` to activate continuous replication

## CI results for containers

See [the Docker Hub page](https://hub.docker.com/r/falldamage/plastic-cloud-to-ucb/builds/) for build status.

## Testing on your local machine

Perform all activity from within the Docker terminal.

### Build Docker containers

Run `./commands/build.sh`

### Start Docker containers

Run `./commands/up.sh`

### Configure Docker containers to talk to each other and Plastic Cloud

Copy profiles.conf, cryptedservers.conf & *.key files from `C:\Users\<Current user>\AppData\Local\plastic4` to `temp`

Run `./commands/configure.sh`

### Prepare for replication of a Plastic Cloud repository

Run `./commands/create_repo.sh <reponame>`

### Replicate a branch in repository from Plastic Cloud to the Git server running inside the VM

Run `./commands/replicate_repo_branch.sh <reponame> <branchname>`

### Configure Git server to accept logins from Unity Cloud Build for one specific project

Begin setup of the build job in Unity Cloud Build; URL = `ssh://git@<Docker machine external IP>:2222/repos/<reponame>.git`

Copy the SSH public key that Unity Cloud Build will use into a file named `temp/id_rsa.<reponame>.pub`

Run `./commands/configure.sh`

Unity Cloud Build should now be able to access the repository on your Git server.

### Install a 1-year Plastic license

Request a Plastic Team Edition 1-year license for 1 user via https://plasticscm.com . Then copy the `plasticd.lic` file into `temp`, and reconfigure.

### Start continuous replication

Run `./commands/start_replication_service.sh`

### Stop continuous replication

Run `./commands/stop_replication_service.sh`

### Remove repository from Git server

Run `./commands/remove_repo.sh <reponame>`

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

### Access your VM in Google Compute Engine

Run `eval $(./commands/gce/gcloud.sh) compute ssh plastic-cloud-to-ucb-gce` 

### Remove your VM from Google Compute Engine

Run `./commands/gce/destroy_host.sh`
   
## Thanks

Thanks to Miguel González for the original Plastic server project: https://github.com/mig42/plastic-docker

Thanks to José Carlos Bernárdez for the original Git server project: https://github.com/jkarlosb/git-server-docker

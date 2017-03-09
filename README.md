# Bridge from Plastic Cloud to Unity Cloud Build

Consists of two docker containers.

1. Plastic server/client. This will replicate from repos in Plastic Cloud, and push to Git server. Originally based on https://github.com/kalmalyzer/plastic-docker image.
2. Git server. Originally based on https://hub.docker.com/r/jkarlos/git-server-docker

To build:

	docker-compose build

To start:

	docker-compose up -d

To setup containers and initialize volumes:

	# Set up "git" user SSH account
	ssh-keygen -t rsa -N "" -f id_rsa
	docker cp id_rsa.pub git-server:/git-server/keys	
	docker-compose restart git-server

	# Set up replication link
	<copy cryptedservers.conf & *.key from PlasticSCM5\server directory to current working dir>
	docker cp cryptedservers.conf plastic:/conf
	docker cp *.key plastic:/conf
	docker exec plastic sed -i 's/ / \/conf\//g' /conf/cryptedservers.conf
	docker-compose restart plastic

	# Enable plastic container to talk to Git via SSH
	docker cp id_rsa plastic:/conf
	docker-compose restart plastic
	
To run a Bash shell within plastic:

	docker exec -it plastic bash


To initialize replication from a Plastic Cloud repo to a Git repo:

	docker exec -it plastic bash
		/root/initrepo.sh <repository>
	
To replicate the /main branch from a Plastic Cloud repo to a Git repo:

	docker exec -it plastic bash
		/root/replicate.sh <repository> <organization>

To delete an initialized/replicated repo:

	docker exec -it plastic bash
		/root/rmrepo.sh <repository>
	
Azure steps:

	Install Python 2.x or 3.x - https://www.python.org/downloads/
	Install Azure CLI - https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

	# Using Azure CLI with docker extension
	https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-linux-dockerextension

	# Using docker-machine with Azure driver
	https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-linux-docker-machine

	az login
	note down your Azure subscription ID (the "id" field)

	# TODO: pick --azure-size  ... A2 is default
	docker-machine create --driver azure --azure-subscription-id <your Azure subscription ID> --azure-resource-group plastic-cloud-to-ucb --azure-availability-set plastic-cloud-to-ucb --azure-ssh-user ops --azure-location=northeurope plastic-cloud-to-ucb

	# List Docker settings for machine in Azure + instructions on how to config to work against it
	docker-machine env plastic-cloud-to-ucb
	
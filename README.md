# Bridge from Plastic Cloud to Unity Cloud Build

Glue logic which enables Unity Cloud Build to build from Plastic Cloud repositories. This is accomplished by running some bridge repositories on a machine in the Azure cloud.

Current state:
	It works, but it does not replicate automatically. Replication needs to be triggered manually each time.



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

To set up a machine in Azure:

	az login
	note down your Azure subscription ID (the "id" field)

	docker-machine create --driver azure --azure-subscription-id <your Azure subscription ID> --azure-resource-group plastic-cloud-to-ucb --azure-availability-set plastic-cloud-to-ucb --azure-ssh-user ops --azure-open-port 2222 --azure-location=northeurope --azure-vnet plastic-cloud-to-ucb plastic-cloud-to-ucb

To configure & run software

	docker-machine env plastic-cloud-to-ucb
	<Follow instructions on last line of output message>

	Follow all installation steps above

Activate Unity Cloud Build for repo:

	docker-machine ip plastic-cloud-to-ucb
	<write down IP>

	Go to Unity Cloud Build, source repo URL is:
		ssh://git@<ip>:2222/git-server/repos/<reponame>.git

	Copy the SSH private key to a file called id_rsa.ucb.pub
	docker cp id_rsa.pub git-server:/git-server/keys	
	docker-compose restart git-server

	Activate Unity Cloud Build! UCB should now be able to connect.


# Bridge from Plastic Cloud to Unity Cloud Build

Consists of two docker containers.

1. Plastic server/client. This will replicate from repos in Plastic Cloud, and push to Git server. Originally based on https://github.com/kalmalyzer/plastic-docker image.
2. Git server. Originally based on https://hub.docker.com/r/jkarlos/git-server-docker

To build:

	docker-compose build

To setup containers and initialize volumes:

	# Set up "git" user SSH account
	ssh-keygen -t rsa -N "" -f id_rsa
	docker cp id_rsa.pub git-server:/git-server/keys	
	docker-compose restart git-server
	
To start:

	docker-compose up -d

To run a Bash shell within plastic:

	docker exec -it plastic bash


To initialize replication from a Plastic Cloud repo to a local Plastic repo:

	docker exec -it plastic bash
	cm mkrep <repository>
	cm replicate <branch>@<repository>@<organization>@Cloud <repo>
		enter username & password for Plastic Cloud

# PlasticSCM Docker container

To build:

    docker build --rm=true -t <your_repo_name> plastic

To run:

    docker run -d -P --name <name> -v <logs_path>:/logs -v [<db_path>:]/db/sqlite <image_name> 

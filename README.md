# PlasticSCM Docker image

To build:

    docker build --rm=true -t <image_name> plastic

To run:

    docker run --name plastic_data <image_name> echo "My data container"
    docker run -d -P --name plastic_server --volumes-from plastic_data <image_name>

To add a user:

    docker run --rm --volumes-from plastic_data <image_name> umtool cu <user_name> <user_password>

To refresh the server:

    docker restart plastic_server

To backup the databases:

    mkdir backup
    docker run --rm --volumes-from plastic_data -v $(pwd)/backup:/backup <image_name> tar cvf /backup/databases_backup_$(date).tar /db/sqlite

To retrieve logs:

    # Console
    docker logs plastic_server
    # Files
    mkdir /log_backup
    docker run --rm --volumes-from plastic_data -v $(pwd)/logs:/log_backup <image_name> tar cvf /log_backup/logs_$(date).tar /logs


# Ensure .ssh folder has appropriate permissions, even if the container is built on Windows
chmod 700 .ssh

# Launch Plastic server in daemon mode
/opt/plasticscm5/server/plasticd --daemon

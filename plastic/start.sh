
# Ensure .ssh folder has appropriate permissions, even if the container is built on Windows
chmod 700 .ssh

# Ensure id_rsa file has appropriate permissions, even if the container is built on Windows
if [ "$(ls -A /conf/id_rsa)" ]; then
  chmod 700 /conf/id_rsa
fi

# Launch Plastic server in daemon mode
/opt/plasticscm5/server/plasticd --daemon

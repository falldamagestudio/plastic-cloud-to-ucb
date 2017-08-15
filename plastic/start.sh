
# Ensure /root/.ssh folder has appropriate permissions, even if the container is built on Windows
chmod 700 /root/.ssh

# Ensure id_rsa file has appropriate permissions, even if the container is built on Windows
if [ "$(ls -A /conf/id_rsa)" ]; then
  chmod 600 /conf/id_rsa
fi

# Ensure known_hosts file has appropriate permissions, even if the container is built on Windows
if [ "$(ls -A /conf/known_hosts)" ]; then
  chmod 600 /conf/known_hosts
fi

# Ensure ssh_config file has appropriate permissions, even if the container is built on Windows
if [ "$(ls -A /conf/ssh_config)" ]; then
  chmod 600 /conf/ssh_config
fi

# Launch Plastic server in daemon mode
/opt/plasticscm5/server/plasticd --daemon

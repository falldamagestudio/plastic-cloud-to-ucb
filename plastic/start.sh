
# Ensure /root/.ssh folder has appropriate permissions, even if the container is built on Windows
chmod 700 /root/.ssh

# Ensure id_rsa file has appropriate permissions, even if the container is built on Windows
if [ "$(ls -A /conf/id_rsa)" ]; then
  chmod 700 /conf/id_rsa
fi

# Add SSH key for git-server to known_hosts, in case there is no such entry yet
# This is convoluted because we are on Ubuntu which stores host names in hashed form in known_hosts
# Because of this, ssh-keyscan -f <original file> will not work
# The solution below will not complain if the keys change for git-server either
# (both old and new keys will be retained) but we will assume that this is not a big enough
# security problem
touch /root/.ssh/known_hosts
cp /root/.ssh/known_hosts /root/.ssh/known_hosts_non_unique
ssh-keyscan -H git-server >> /root/.ssh/known_hosts_non_unique
sort -u < /root/.ssh/known_hosts_non_unique > /root/.ssh/known_hosts
rm /root/.ssh/known_hosts_non_unique
chmod 600 /root/.ssh/known_hosts

# Launch Plastic server in daemon mode
/opt/plasticscm5/server/plasticd --daemon

#!/bin/sh

# Get host keys for git-server and <ip address for git-server>
ssh-keyscan git-server `getent hosts git-server | awk '{ print $1 }'` >/conf/known_hosts
chmod 600 /conf/known_hosts

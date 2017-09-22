#!/bin/sh

if [ $# -lt 2 ]; then
  echo "Usage: replicate_repo_branch.sh <reponame> <branchname>"
  exit 1
fi

reponame="$1"
branchname="$2"

docker exec plastic /root/replicate-branch-from-plastic-cloud.sh "$reponame" "$branchname"
docker exec plastic /root/replicate-repo-to-local-git-server.sh "$reponame"
echo "Branch ""$branchname"" is available in Git repo at ssh://git@<docker machine IP>:2222/repos/""$reponame"".git"

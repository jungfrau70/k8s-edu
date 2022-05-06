#!/bin/sh

docker rm -f $(docker ps -qa)
docker volume rm $(docker volume ls -q)
cleanupdirs="/var/lib/docker var/lib/containerd"
for dir in $cleanupdirs; do
  echo "Removing $dir"
  rm -rf $dir
done

# apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin
# rm -rf /var/lib/docker
# rm -rf /var/lib/containerd

# DOCKER_CONFIG=?

# docker rm -f $(docker ps -qa)
# docker volume rm $(docker volume ls -q)
# cleanupdirs="/var/lib/etcd /etc/kubernetes /etc/cni /opt/cni /var/lib/cni /var/run/calico /opt/rke"
# for dir in $cleanupdirs; do
#   echo "Removing $dir"
#   rm -rf $dir
# done

# sudo apt-get remove docker docker-engine docker.io containerd runc

# rm $DOCKER_CONFIG/cli-plugins/docker-compose

# rm /usr/local/lib/docker/cli-plugins/docker-compose
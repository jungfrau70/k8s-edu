#!/bin/bash

# curl -fsSL https://get.docker.com -o get-docker.sh
# sh get-docker.sh

# apt-get update
# apt-get install \
#     ca-certificates \
#     curl \
#     gnupg \
#     lsb-release

# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# apt-get update
# apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin


# ########################################################################333

# apt-get purge docker-engine
# apt-get autoremove --purge docker-engine
# rm -rf /var/lib/docker

# apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli
# apt-get autoremove -y --purge docker-engine docker docker.io docker-ce  

# rm -rf /var/lib/docker /etc/docker
# rm /etc/apparmor.d/docker
# groupdel docker
# rm -rf /var/run/docker.sock

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt-cache policy docker-ce
apt install -y docker-ce
systemctl status docker
docker-version
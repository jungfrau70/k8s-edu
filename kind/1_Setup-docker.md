Prerequsites:
- deploy-server

References:
- https://docs.docker.com/engine/install/
- https://mcvidanagama.medium.com/set-up-a-multi-node-kubernetes-cluster-locally-using-kind-eafd46dd63e5
- https://kind.sigs.k8s.io/docs/user/configuration/
- https://github.com/kubernetes-sigs/kind/releases

export WORKDIR='/root/k8s-in-docker/kind'
cd $WORKDIR

################################################################################################
# 1. Install docker & docker-compose
################################################################################################

cat /etc/os-release

bash config/install-docker.sh

systemctl start docker
systemctl enable docker
docker --version

bash config/install-docker-compose.sh
docker-compose --version

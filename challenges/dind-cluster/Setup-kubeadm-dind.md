Prerequsites:
- deploy-server

References:
- https://www.composerize.com/

export WORKDIR='/root/k8s/kubeadm-dind'
cd $WORKDIR

################################################################################################
# 3. Backup tokens
################################################################################################

wget -O dind-cluster.sh https://github.com/kubernetes-sigs/kubeadm-dind-cluster/releases/download/v0.2.0/dind-cluster-v1.14.sh 
chmod +x dind-cluster.sh

# start the cluster
./dind-cluster.sh up

# add kubectl directory to PATH
export PATH="$HOME/.kubeadm-dind-cluster:$PATH"

kubectl get nodes
NAME          STATUS    ROLES     AGE       VERSION
kube-master   Ready     master    4m        v1.14.0
kube-node-1   Ready     <none>    2m        v1.14.0
kube-node-2   Ready     <none>    2m        v1.14.0

# k8s dashboard available at http://localhost:<DOCKER_EXPOSED_PORT>/api/v1/namespaces/kube-system/services/kubernetes-dashboard:/proxy. See your console for the URL.

http://localhost:49153/api/v1/namespaces/kube-system/services/kubernetes-dashboard:/proxy/#!/node?namespace=default

# restart the cluster, this should happen much quicker than initial startup
./dind-cluster.sh up

# stop the cluster
./dind-cluster.sh down

# remove DIND containers and volumes
./dind-cluster.sh clean
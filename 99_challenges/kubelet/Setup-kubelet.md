Prerequsites:
- deploy-server

References:
- https://www.composerize.com/

export WORKDIR='/root/k8s/kubelet'
cd $WORKDIR

#########################################################################################
# 1. Install kubelet
#########################################################################################

wget https://storage.googleapis.com/kubernetes-release/release/v1.0.3/bin/linux/amd64/
wget https://storage.googleapis.com/kubernetes-release/release/v1.24.0/bin/linux/amd64/kubelet
chmod +x kubelet

./kubelet --help

mkdir manifests
./kubelet --config=$PWD/manifests 


#########################################################################################
# 1. Instanticate the containers
#########################################################################################

curl -L https://github.com/kubernetes/kompose/releases/download/v1.26.0/kompose-linux-amd64 -o kompose
chmod u+x kompose && mv kompose /usr/local/bin/kompose

kompose convert

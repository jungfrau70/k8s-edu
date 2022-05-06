Prerequsites:
- deploy-server

References:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
- https://mcvidanagama.medium.com/set-up-a-multi-node-kubernetes-cluster-locally-using-kind-eafd46dd63e5
- https://kind.sigs.k8s.io/docs/user/configuration/
- https://github.com/kubernetes-sigs/kind/releases

export WORKDIR='/root/k8s-in-docker/kind'
cd $WORKDIR

################################################################################################
# 1. Install kubeadm
################################################################################################

cat >>config/install-kubeadm.sh<<EOFEOF
#!/bin/bash
cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl

curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
EOFEOF

bash config/install-kubeadm.sh

################################################################################################
# 2. Uninstall docker
################################################################################################

. ./config/uninstall-docker.sh 
which docker
rm /usr/bin/docker
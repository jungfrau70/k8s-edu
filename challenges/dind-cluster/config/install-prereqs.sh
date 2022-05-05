#!/bin/bash

echo "Updating Ubuntu..."
apt-get update -y
apt-get upgrade -y

systemctl start docker

echo "Install os requirements"
apt-get install -y \
  curl \
  apt-transport-https \
  dialog \
  python \
  daemon

apt-get update -y
apt-get install -y     apt-transport-https     ca-certificates     curl     gnupg     lsb-release

cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

echo "Add Kubernetes repo..."
sh -c 'curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -'
sh -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
apt-get update -y

echo "Installing Kubernetes requirements..."
apt-get install -y \
  kubelet

# This is temporary fix until new version will be released
sed -i 38,40d /var/lib/dpkg/info/kubelet.postinst

apt-get install -y \
  kubernetes-cni \
  kubectl \
  kubeadm

# apt-get install software-properties-common
# add-apt-repository universe multiverse
# ln -s /usr/share/pyshared/lsb_release.py /usr/lib/python3/dist-packages/lsb_release.py 

# echo \
#   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# apt-get update -y
# apt-get install docker-ce docker-ce-cli containerd.io -y



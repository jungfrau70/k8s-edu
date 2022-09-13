#!/bin/bash

apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl

curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt-mark unhold kubelet kubeadm kubectl
apt-get remove -y kubelet kubeadm kubectl

apt-get update -y

apt-get install -y kubeadm=1.19.6-00 kubelet=1.19.6-00 kubectl=1.19.6-00

#Kubernetes is removing dockershim in the upcoming v1.24 release.
#apt-get install -y kubeadm=1.24.0-00 kubelet=1.24.0-00 kubectl=1.24.0-00
#apt-get install -y kubelet kubeadm kubectl

apt-mark hold kubelet kubeadm kubectl


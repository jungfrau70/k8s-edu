#!!/bin/bash

kubeadm reset

directories="/var/lib/kubelet /etc/kubernetes/manifests /etc/kubernetes/pki \
/etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf \
/etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf \
/var/lib/etcd /var/lib/kubelet /var/lib/dockershim /var/run/kubernetes /var/lib/cni"

for target in $directories
do
    echo $target
    rm -rf $target && echo $target "deleted"
    ls -al $target || echo $target "not exists"
done
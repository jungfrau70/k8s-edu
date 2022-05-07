Prerequsites:
- deploy-server

References:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/


export WORKDIR='/root/k8s-in-docker/2_kubelet'
cd $WORKDIR

################################################################################################
# 1. Letting iptables see bridged traffic
################################################################################################

cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

################################################################################################
# 2. Check container runtime engine
################################################################################################

## kubernetes 1.16
systemctl status kubelet
systemctl status docker

or

## kubernetes 1.24 (without dockershim)
systemctl status kubelet
systemctl status containerd

################################################################################################
# 2. Install kubelet / kubeadm / kubectl
################################################################################################

## kubernetes 1.16
bash config/install-kubelet-1.16.9.sh

or

## kubernetes 1.24 (without dockershim)
bash config/install-kubelet-1.24.0.sh

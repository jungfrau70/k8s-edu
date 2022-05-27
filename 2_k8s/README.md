# k8s-cluster-root
# k8s-cluster-root

cd 1_k8s

bash config/kubeadm-reset.sh
bash config/install-prereqs.sh
bash config/configure-prereqs.sh

bash config/install-k8s-cluster.sh | tee info/installion-info.txt
# k8s-cluster-root

cd 4_k8s

bash config/0_kubeadm-reset.sh 
bash config/1_install-prereqs.sh 
swapoff -a
vi /etc/fstab

bash config/2_install-k8s-cluster.sh | tee info/installion-info.txt

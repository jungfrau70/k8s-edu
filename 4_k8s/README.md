# k8s-cluster-root

################################################################################################
# 1. Create K8s cluster
################################################################################################
cd 4_k8s

bash config/0_kubeadm-reset.sh 
bash config/1_install-prereqs.sh 
swapoff -a
vi /etc/fstab

bash config/2_install-k8s-cluster.sh | tee info/installion-info.txt

################################################################################################
# 2. Untaint NoSchedule from master node - ubuntu
################################################################################################
# Current 
kubectl get po -A  # ==> Pending pods exist

# Untaint
kubectl taint node ubuntu node-role.kubernetes.io/master-

# To-be
kubectl get po -A  # ==> No pending pods

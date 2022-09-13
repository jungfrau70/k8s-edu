Prerequsites:
- deploy-server

References:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
- https://gruuuuu.github.io/cloud/k8s-taint-toleration/
- https://www.golinuxcloud.com/kubernetes-add-label-to-running-pod/

export WORKDIR='/root/k8s-in-docker/3_k8s'
cd $WORKDIR


################################################################################################
# 0. Swapoff
################################################################################################

swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab
systemctl mask dev-sda3.swap
top
# (if required) reboot


################################################################################################
# 1. Reset cluster with kubeadm
################################################################################################

kubeadm reset -y
rm -rf /var/lib/etcd
rm -rf /etc/kubernetes/manifests
rm -rf $HOME/.kube

################################################################################################
# 2. Create a ha cluster with kubeadm
################################################################################################

kubeadm init --control-plane-endpoint "localhost:6443"
kubeadm init --pod-network-cidr=10.217.0.0/16 --control-plane-endpoint "localhost:16443" --upload-certs

## copy tokens
cat <<EOF | tee worker.join
kubeadm join localhost:6443 --token r33qu5.nbcrzy5o2kqu3bpy \
    --discovery-token-ca-cert-hash sha256:e208d27c24746c5103112eeb07756805f340fda9c88a26601a4746c451fdfb00 
EOF

cat <<EOF | tee control-plane.join
  kubeadm join localhost:6443 --token r33qu5.nbcrzy5o2kqu3bpy \
    --discovery-token-ca-cert-hash sha256:e208d27c24746c5103112eeb07756805f340fda9c88a26601a4746c451fdfb00 \
    --control-plane  
EOF


################################################################################################
# 3. Make the user to run kubectl by copying csr 
################################################################################################

rm -rf $HOME/.kube
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

################################################################################################
# 4. Get cluster-info
################################################################################################

kubectl cluster-info
kubectl get no

################################################################################################
# 5. Deploy a pod network to the cluster
################################################################################################

kubectl create \
-f https://raw.githubusercontent.com/cilium/cilium/v1.6/install/kubernetes/quick-install.yaml


################################################################################################
# 6. Get pods
################################################################################################

watch kubectl get po -A
kubectl get pods -n kube-system --selector=k8s-app=cilium

################################################################################################
# 7. Control plane node isolation
################################################################################################

bash config/untaint-all-nodes.sh

################################################################################################
# 8. Create pods
################################################################################################
	
kubectl run nginx --image nginx --port=80

################################################################################################
# 9. Label and ...
################################################################################################

# kubectl label pods  <label-name>
kubectl label pods nginx-5578584966-psd2r app=web 

# kubectl get po <your-pod-name> -o yaml 
kubectl get pods nginx-5578584966-psd2r -o yaml > nginx-pod.yaml


################################################################################################
# 10. Create deployment & Scale In/Out
# kubectl create deployment NAME --image=image -- [COMMAND] [args...]
################################################################################################

kubectl create deployment nginx3 --image=nginx
kubectl get deployment nginx3 -o yaml

kubectl scale deploy nginx3 --replicas=3
kubectl get po

kubectl scale deploy nginx3 --replicas=1
kubectl get po


################################################################################################
# 11. Expose
################################################################################################

kubectl expose deployment nginx3 --type=NodePort --port 30100
kubectl get svc

curl xxx.xxx.xxx.xxx:30100
Prerequsites:
- deploy-server

References:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
- https://gruuuuu.github.io/cloud/k8s-taint-toleration/
- https://www.golinuxcloud.com/kubernetes-add-label-to-running-pod/
- https://velog.io/@whereisdw/kubernetes-k8s-1.24%EC%97%90%EC%84%9C-container-%EB%9F%B0%ED%83%80%EC%9E%84-%EB%B3%80%EA%B2%BD-%EB%B0%A9%EB%B2%95

export WORKDIR='/root/k8s-in-docker/3_k8s'
cd $WORKDIR


################################################################################################
# 1. Swapoff
################################################################################################

swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab
systemctl mask dev-sda3.swap
top
# (if required) reboot

################################################################################################
# 2. Create a cluster with kubeadm
################################################################################################

kubeadm init --pod-network-cidr=10.217.0.0/16

## copy tokens
cat <<EOF | tee worker.join
kubeadm join 192.168.54.139:6443 --token 2kccv8.abke32w4ix1wpazl \
        --discovery-token-ca-cert-hash sha256:0f6cae27087161526f77618ac7e685db10fe827ab053d207d85d9a334eecbf30 
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
	
kubectl run nginx --image=nginx --port=80

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
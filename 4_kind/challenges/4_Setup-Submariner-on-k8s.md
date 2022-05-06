Prerequsites:
- deploy-server

References:
- https://medium.com/@jyson88/kubectx-kubens-%EC%84%A4%EC%A0%95-%EB%B0%8F-%EC%9E%90%EB%8F%99-%EC%99%84%EC%84%B1-7b9192113a4d
- https://github.com/ahmetb/kubectx/releases
- https://kubernetes.io/docs/tasks/administer-cluster/

export WORKDIR='/root/k8s/kind'
cd $WORKDIR


################################################################################################
# 1. Apply tigera operator on c1
################################################################################################

kubectx kind-c1
kubectl config get-contexts


kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml

cat >>tigera-c1.yaml<<EOF
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  calicoNetwork:
    ipPools:
      - blockSize: 26
        cidr: 10.240.0.0/16
        encapsulation: VXLANCrossSubnet
        natOutgoing: Enabled
        nodeSelector: all()
EOF

kubectl apply -f tigera-c1.yaml 


################################################################################################
# 2. Apply tigera operator on c2
################################################################################################

kubectx kind-c2
kubectl config get-contexts


kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml

cat >>tigera-c2.yaml<<EOF
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  calicoNetwork:
    ipPools:
      - blockSize: 26
        cidr: 10.241.0.0/16
        encapsulation: VXLANCrossSubnet
        natOutgoing: Enabled
        nodeSelector: all()
EOF

kubectl apply -f tigera-c2.yaml 


################################################################################################
# 3. Check if Calico works
################################################################################################

kubectx kind-c1
kubectl get pod -n calico-system

kubectx kind-c2
kubectl get pod -n calico-system

################################################################################################
# 4. Install Submariner on Kubernetes
################################################################################################

curl -Ls https://get.submariner.io | bash
export PATH=$PATH:~/.local/bin

docker exec -it c1-control-plane /bin/bash

echo $KUBECONFIG
### output
/etc/kubernetes/admin.conf

#ls /etc/kubernetes/admin.conf
#export KUBECONFIG=/etc/kubernetes/admin.conf
#echo $KUBECONFIG

# Open new terminal
docker ps | grep "plane\|worker"
### output
38d8148aeb20   kindest/node:v1.19.1   "/usr/local/bin/entr…"   21 minutes ago   Up 21 minutes   127.0.0.1:43085->6443/tcp   c2-control-plane
65c020158ff4   kindest/node:v1.19.1   "/usr/local/bin/entr…"   21 minutes ago   Up 21 minutes                               c2-worker
ea35427b7f04   kindest/node:v1.19.1   "/usr/local/bin/entr…"   22 minutes ago   Up 22 minutes                               c1-worker
babce7aa576d   kindest/node:v1.19.1   "/usr/local/bin/entr…"   22 minutes ago   Up 22 minutes   127.0.0.1:43615->6443/tcp   c1-control-plane

### Get IP of c2-control-plane
docker inspect c2-control-plane -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
### output
172.19.0.4

################################################################################################
# 5. Install Submariner on Kubernetes
################################################################################################

curl -Ls https://get.submariner.io | bash 
export PATH=$PATH:~/.local/bin
echo export PATH=\$PATH:~/.local/bin \
>> ~/.bashrc

## (deploy-server) deploy borker
subctl deploy-broker

## (deploy-server) label to nodes
kubectl label node c1-worker submariner.io/gateway=true
kubectl label node c2-worker submariner.io/gateway=true --context kind-c2

kubectl get nodes --show-labels --context kind-c1
kubectl get nodes --show-labels --context kind-c2

## (c1-control-plane) join to broker
subctl join broker-info.subm --natt=false --clusterid kind-c1
subctl join broker-info.subm --natt=false --clusterid kind-c2 --kubecontext kind-c2

## list Submariner gateways.
subctl show gateways 
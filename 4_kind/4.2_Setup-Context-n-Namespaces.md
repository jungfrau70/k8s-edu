Prerequsites:
- deploy-server

References:
- https://medium.com/@jyson88/kubectx-kubens-%EC%84%A4%EC%A0%95-%EB%B0%8F-%EC%9E%90%EB%8F%99-%EC%99%84%EC%84%B1-7b9192113a4d
- https://github.com/ahmetb/kubectx/releases
- https://kubernetes.io/docs/tasks/administer-cluster/

export WORKDIR='/root/k8s/kind'
cd $WORKDIR


################################################################################################
# 1. Create cluster c1
################################################################################################

cat >>kind-cluster-c1.yaml<<EOF
kind: Cluster
name: c1
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
networking:
  podSubnet: 10.240.0.0/16
  serviceSubnet: 10.110.0.0/16
  disableDefaultCNI: true
EOF

kind create cluster --config kind-cluster-c1.yaml

################################################################################################
# 2. Create cluster c2
################################################################################################

cat >>kind-cluster-c2.yaml<<EOF
kind: Cluster
name: c2
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
networking:
  podSubnet: 10.241.0.0/16
  serviceSubnet: 10.111.0.0/16
  disableDefaultCNI: true
EOF

kind create cluster --config kind-cluster-c2.yaml

################################################################################################
# 3. Get clusters
################################################################################################

kind get clusters

################################################################################################
# 4. Get context(=cluster)
################################################################################################

kubectl config get-contexts

################################################################################################
# 5. Change context(=cluster)
################################################################################################

## change to c1
kubectl config use-context kind-c1
kubectl config get-contexts

## change to c2
kubectl config use-context kind-c2
kubectl config get-contexts

################################################################################################
# 6. Get namespaces
################################################################################################

kubectl get namespace
kubectl get po

################################################################################################
# 7. Change default namespace
################################################################################################

kubectl config set-context --current --namespace=kube-system
kubectl get po

################################################################################################
# 8. Install kubectx / kubens
################################################################################################

git clone https://github.com/ahmetb/kubectx.git ~/.kubectx
COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
ln -sf ~/.kubectx/completion/kubens.bash $COMPDIR/kubens
ln -sf ~/.kubectx/completion/kubectx.bash $COMPDIR/kubectx
cat << EOF >> ~/.bashrc

## kubectx and kubens
export PATH=~/.kubectx:\$PATH
EOF

## Completion scripts for fish
mkdir -p ~/.config/fish/completions
ln -s /opt/kubectx/completion/kubectx.fish ~/.config/fish/completions/
ln -s /opt/kubectx/completion/kubens.fish ~/.config/fish/completions/


################################################################################################
# 9. Use kubectx / kubens
################################################################################################

kubectx kind-c1
kubectl config get-contexts

kubectx kind-c2
kubectl config get-contexts

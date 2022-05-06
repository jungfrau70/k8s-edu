Prerequsites:
- deploy-server

References:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
- https://mcvidanagama.medium.com/set-up-a-multi-node-kubernetes-cluster-locally-using-kind-eafd46dd63e5
- https://kind.sigs.k8s.io/docs/user/configuration/
- https://github.com/kubernetes-sigs/kind/releases

export WORKDIR='/root/k8s-in-docker/kind'
cd $WORKDIR

################################################################################################
# 1. Install docker & docker-compose
################################################################################################

cat /etc/os-release

bash config/install-docker.sh

systemctl start docker
systemctl enable docker
docker --version

bash config/install-docker-compose.sh
docker-compose --version

################################################################################################
# 2. Install kubectl
################################################################################################

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"


################################################################################################
# 3. Install Kind
################################################################################################

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind

################################################################################################
# 4. Create the clusters
################################################################################################

cat > kind-prd-config.yaml <<EOF
# three node (two workers) cluster config
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: prd
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: ClusterConfiguration
    apiServer:
        extraArgs:
          enable-admission-plugins: NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: ClusterConfiguration
    apiServer:
        extraArgs:
          enable-admission-plugins: NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: ClusterConfiguration
    apiServer:
        extraArgs:
          enable-admission-plugins: NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook
- role: worker
- role: worker
- role: worker
networking:
  serviceSubnet: "10.96.0.0/12"
  podSubnet: "10.244.0.0/16"
  kubeProxyMode: "ipvs"
EOF

## Create the first cluster
kind create cluster --config kind-prd-config.yaml

kubectl cluster-info --context kind-prd

## (option) customize configurations
cp kind-prd-config.yaml kind-stg-config.yaml
sed -i 's/name: prd/name: stg/g' kind-stg-config.yaml
sed -i 's/ipvs/iptables/g' kind-stg-config.yaml

unset array
array=$(grep -wn "control-plane" kind-stg-config.yaml | cut -d: -f1)
read -d'\n' -a array < <(printf '%s\n' "${array[@]}"|tac)
echo "${array[@]}"

for num in `echo "${array[@]}"`
do
    echo $num
    line=$num"a\  image: kindest/node:???"
    echo $line
    sed -i "$line" kind-stg-config.yaml;
done 

unset array
array=$(grep -wn "worker" kind-stg-config.yaml | cut -d: -f1)
read -d'\n' -a array < <(printf '%s\n' "${array[@]}"|tac)
echo "${array[@]}"

for num in `echo "${array[@]}"`
do
    echo $num
    line=$num"a\  image: kindest/node:???"
    echo $line
    sed -i "$line" kind-stg-config.yaml;
done 

## Create another cluster
kind create cluster --config kind-stg-config.yaml

################################################################################################
# 5. Delete the cluster
################################################################################################

kind delete cluster --name prd
kind delete cluster --name stg

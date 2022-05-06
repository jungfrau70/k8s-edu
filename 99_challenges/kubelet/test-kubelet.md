
################################################################################################
# 1. Download kubelet
################################################################################################

wget https://storage.googleapis.com/kubernetes-release/release/v1.0.3/bin/linux/amd64/kubelet
chmod +x kubelet

wget https://storage.googleapis.com/kubernetes-release/release/v1.24.0/bin/linux/amd64/kubelet
chmod +x kubelet

./kubelet --help

mkdir manifests
./kubelet --config=$PWD/manifests \
--image-service-endpoint=tcp://localhost:3735


nodes="kmaster1 kmaster2 kmaster3 kworker1 kworker2 kworker3"
for node in $nodes
do
    docker cp ./install-k8s-prereqs.sh $node
done

. ./install-k8s-prereqs.sh


################################################################################################
# 1. Initialize kubeadm
################################################################################################

kubeadm init --ignore-preflight-errors=all


################################################################################################
# 1. Push to github
################################################################################################

echo "# k8s-in-docker" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/jungfrau70/k8s-in-docker.git
git push -u origin master

git add .
git commit -m "updated"
git push -u origin master
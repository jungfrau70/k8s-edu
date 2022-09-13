Prerequsites:
- deploy-server

References:
- https://www.jetstack.io/blog/k8s-getting-started-part2/
- https://www.golinuxcloud.com/kubernetes-add-label-to-running-pod/
- https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes
- https://www.composerize.com/

export WORKDIR='/root/k8s-in-docker/5_hyperkube'
cd $WORKDIR


#########################################################################################
# 1. Cleanup all containers
#########################################################################################

## list
docker ps -a

## Remove
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)


#########################################################################################
# 2. Run hyperkube-k8s
#########################################################################################

#export HOSTNAME=172.20.34.112

export K8S_VERSION=v1.2.2
export HOSTNAME=127.0.0.1 
docker run \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:rw \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged=true \
    --name=master \
    -d \
    gcr.io/google_containers/hyperkube-amd64:${K8S_VERSION} \
    /hyperkube kubelet \
        --api_servers=http://localhost:8080 \
        --v=2 \
        --address=0.0.0.0 \
        --enable_server \
        --hostname_override=${HOSTNAME} \
        --containerized \
        --config=/etc/kubernetes/manifests
#    jetstack/hyperkube:v0.20.1 \


#########################################################################################
# 3. Run Proxy
#########################################################################################

docker run -d \
   --net=host \
   --privileged \
   --name=kube-proxy \
   gcr.io/google_containers/hyperkube-amd64:${K8S_VERSION} \
   /hyperkube proxy \
        --master=http://127.0.0.1:8080 \
        --v=2


#########################################################################################
# 4. Run ./kubectl
#########################################################################################

wget https://storage.googleapis.com/kubernetes-release/release/v0.20.1/bin/linux/amd64/kubectl -O kubectl
chmod u+x kubectl
#sudo  mv kubectl /usr/local/bin/

./kubectl get no
./kubectl get po


################################################################################################
# 5. Create pods
################################################################################################
	
./kubectl run nginx --image=nginx --port=80


################################################################################################
# 6. Label and ...
################################################################################################

# kubectl label pods  <label-name>
./kubectl label pods nginx-26itp  app=web 

# kubectl get po <your-pod-name> -o yaml 
./kubectl get pods nginx-5578584966-psd2r -o yaml > nginx-pod.yaml


################################################################################################
# 7. Create deployment & Scale In/Out
# kubectl create deployment NAME --image=image -- [COMMAND] [args...]
################################################################################################

kubectl create deployment nginx3 --image=nginx
kubectl get deployment nginx3 -o yaml

kubectl scale deploy nginx3 --replicas=3
kubectl get po

kubectl scale deploy nginx3 --replicas=1
kubectl get po


################################################################################################
# 8. Expose
################################################################################################

kubectl expose deployment nginx3 --type=NodePort --port 30100
kubectl get svc

curl xxx.xxx.xxx.xxx:30100


#########################################################################################
# A. Cleanup all containers
#########################################################################################

## list
docker ps -a

## Remove
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)


#########################################################################################
# B. Trouble Shooting
#########################################################################################

# ref: https://serverfault.com/questions/772203/unable-to-run-hyperkube-kubernetes-locally-via-docker

kubectl -s http://localhost:8080 cluster-info

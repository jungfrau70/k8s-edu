#!/bin/bash

kubeadm version

systemctl status docker | tee

sleep 2

systemctl status kubelet | tee

cat <<EOF | sudo tee /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF

systemctl daemon-reload && \
systemctl restart docker

systemctl status docker | tee



#!/bin/bash

kubeadm token create --print-join-command > k8s-join-command.sh
scp k8s-join-command.sh node1:~

#kubeadm token create --print-join-command | bash -f -


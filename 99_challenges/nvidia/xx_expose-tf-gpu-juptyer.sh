#!/bin/bash

#kubectl get pod -l app=tf-gpu-jupyter

#kubectl logs -l app=tf-gpu-jupyter

#kubectl port-forward pod/tf-gpu-jupyter-66f89b64cd-vrllc 8888:8888

kubectl get po -l app=tf-gpu-jupyter | awk '{print $1}' | grep -i tf | kubectl port-forward `awk '{print $1}'` 8888:8888


#!/bin/bash

cat <<EOF | kubectl delete -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: tf-gpu-jupyter
  name: tf-gpu-jupyter
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tf-gpu-jupyter
  template:
    metadata:
      labels:
        app: tf-gpu-jupyter
    spec:
      containers:
      - image: tensorflow/tensorflow:2.1.0-gpu-py3-jupyter
        imagePullPolicy: IfNotPresent
        name: tf-gpu-jupyter
        ports:
        - containerPort: 8888
          protocol: TCP
        resources:
          limits:
            nvidia.com/gpu: "1"
EOF

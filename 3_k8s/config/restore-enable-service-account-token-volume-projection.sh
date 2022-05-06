#!/bin/bash

$ sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
...
        - --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
        - --service-account-issuer=api
        - --service-account-api-audiences=api,vault

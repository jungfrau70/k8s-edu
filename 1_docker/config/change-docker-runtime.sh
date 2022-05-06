#!/bin/bash

"""
$ sudo vi /etc/docker/daemon.json
    {
      "default-runtime": "nvidia", 
      "runtimes": {
        "nvidia": {
          "path": "nvidia-container-runtime",
          "runtimeArgs": []
        }
      }
    }
"""

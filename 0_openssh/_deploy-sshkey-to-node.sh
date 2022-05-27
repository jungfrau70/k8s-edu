#!/bin/bash

ssh-copy-id node1
scp /etc/hosts node1:/etc/hosts

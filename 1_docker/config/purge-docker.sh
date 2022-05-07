#!/bin/bash

systemctl stop docker
apt purge -y docker-ce docker-ce-cli
apt autoremove -y 
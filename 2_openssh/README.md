bash install-openssh-ubuntu1804.sh

systemctl enable ssh.service
systemctl daemon-reload
systemctl restart ssh

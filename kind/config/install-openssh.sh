#!/bin/bash

cat >install-openssh.sh<<EOF
#!/bin/bash

# centos 7
# yum install -y openssh-server openssh-clients openssh-askpass

# ubuntu 18.04
apt-get update -y 
apt-get install -y openssh-server

echo "/etc/ssh/ssh_config"
sed -i '/StrictHostKeyChecking/s/^#[ \t]*//g' /etc/ssh/ssh_config
# sed -i 's/StrictHostKeyChecking ask/StrictHostKeyChecking no/g' /etc/ssh/ssh_config
# sed -i 's/StrictHostKeyChecking True/StrictHostKeyChecking no/g' /etc/ssh/ssh_config
sed -i '/#   PasswordAuthentication yes/s/^#[ \t]*//g' /etc/ssh/ssh_config
cat /etc/ssh/ssh_config | grep -v ^# | grep -v ^$

echo ""
echo "/etc/ssh/sshd_config"
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i '/#PasswordAuthentication yes/s/^#[ \t]*//g' /etc/ssh/sshd_config
cat /etc/ssh/sshd_config | grep -v ^# | grep -v ^$

systemctl restart ssh.service
systemctl status sshd 
systemctl enable ssh.service
EOF

chmod u+x install-openssh.sh

. ./install-openssh.sh

# nodes='master worker1 worker2 worker3' 
# for node in $nodes 
# do 
#     docker cp install-openssh.sh $node:/root/ 
#     docker exec -it $node /bin/bash /root/install-openssh.sh 
# done
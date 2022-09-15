# /etc/kubernetes/pki
ls -al /etc/kubernetes/pki
total 68
drwxr-xr-x 3 root root 4096 Sep 13 11:40 ./
drwxr-xr-x 4 root root 4096 Sep 13 11:40 ../
-rw-r--r-- 1 root root 1261 Sep 13 11:40 apiserver.crt
-rw-r--r-- 1 root root 1135 Sep 13 11:40 apiserver-etcd-client.crt
-rw------- 1 root root 1679 Sep 13 11:40 apiserver-etcd-client.key
-rw------- 1 root root 1675 Sep 13 11:40 apiserver.key
-rw-r--r-- 1 root root 1143 Sep 13 11:40 apiserver-kubelet-client.crt
-rw------- 1 root root 1675 Sep 13 11:40 apiserver-kubelet-client.key
-rw-r--r-- 1 root root 1066 Sep 13 11:40 ca.crt
-rw------- 1 root root 1679 Sep 13 11:40 ca.key
drwxr-xr-x 2 root root 4096 Sep 13 11:40 etcd/
-rw-r--r-- 1 root root 1078 Sep 13 11:40 front-proxy-ca.crt
-rw------- 1 root root 1679 Sep 13 11:40 front-proxy-ca.key
-rw-r--r-- 1 root root 1103 Sep 13 11:40 front-proxy-client.crt
-rw------- 1 root root 1675 Sep 13 11:40 front-proxy-client.key
-rw------- 1 root root 1675 Sep 13 11:40 sa.key
-rw------- 1 root root  451 Sep 13 11:40 sa.pub

# cat /etc/kubernetes/scheduler.conf

# cat /etc/kubernetes/controller-manager.conf

# cat /etc/kubernetes/admin.conf

# cat /etc/kubernetes/kubelet.conf
# ls -al /var/lib/kubelet/pki/
Prerequsites:
- deploy-server

References:
- https://www.composerize.com/

export WORKDIR='/root/k8s-in-docker/challenges/api-proxy'
cd $WORKDIR

#########################################################################################
# 1. Create nginx.conf
#########################################################################################

mkdir /etc/nginx
cat <<EOF | tee /etc/nginx/nginx.conf
events {}
stream {
    upstream stream_backend {
        least_conn;
        server 172.18.0.41:6443;
        server 172.18.0.42:6443;
        server 172.18.0.43:6443;
    }

    server {
        listen  6443;
        proxy_pass  stream_backend;
        proxy_timeout   300s;
        proxy_connect_timeout   1s;
    }
}
EOF

#########################################################################################
# 2. Instanticate the containers
#########################################################################################

## (Option #1)
docker run --name proxy -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf:ro --restart=always -p 6443:6443 -d nginx

## (Option #2)
docker-compose up -d

## Monitor containers
docker stats

## (Option #3)
GOTO ::: Setup-kubelet.md


#########################################################################################
# 3. Test connectivity
#########################################################################################

curl localhost:6440

(base) [root@deploy-server k8s]# curl localhost:6443
curl: (52) Empty reply from server

(base) [root@deploy-server k8s]# curl localhost:6440
curl: (7) Failed connect to localhost:6440; Connection refused
Prerequsites:
- deploy-server

References:
- https://www.composerize.com/

export WORKDIR='/root/k8s/controller-plane'
cd $WORKDIR

#########################################################################################
# 1. Create nginx.conf
#########################################################################################

## Create docker-compose.yml

cat >>docker-compose.yml<<EOF
version: '3.7'

services:
  kmaster1:
    hostname: kmaster1
    container_name: kmaster1
    image: jungfrau70/ubuntu-k8s-master.1
    build:
      context: .
      dockerfile: Dockerfile.k8s-master
    cap_add:
    - SYS_ADMIN
    environment:
    - container=docker
    command: >
      /sbin/init
    restart: always
    networks:
      netgroup:
        ipv4_address: 172.18.0.41
    ports:
      - "2424:2424"
      - "2480:2480"
    tmpfs:
      - /run
      - /run/lock
      - /tmp
    volumes:
      # Just specify a path and let the Engine create a volume
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
      - /var/run/docker.sock:/var/run/containerd/containerd.sock:ro
      - type: bind
        source: /etc/hosts
        target: /etc/hosts
    security_opt:
      - seccomp:unconfined
networks:
  netgroup:
    name: netgroup
    driver: bridge
    attachable: true
    ipam:
      config:
        - subnet: 172.18.0.0/16
          gateway: 172.18.0.1
EOF

docker-compose up -d -f docker-compose.yml

#########################################################################################
# 2. Instanticate the containers
#########################################################################################

## (Option #1)
docker-compose -f docker-compose.yml up -d 

## Monitor containers
docker stats

## (Option #2)
# docker run --name proxy -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
# --restart=always -p 6443:6443 -d nginx


#########################################################################################
# 3. Test api-proxy(=loadbalancer) connectivity
#########################################################################################

curl 172.18.0.49:6443

(base) [root@deploy-server k8s]# curl 172.18.0.49:6443
curl: (56) Recv failure: Connection reset by peer

(base) [root@deploy-server k8s]# curl 172.18.0.49:6440
curl: (7) Failed to connect to 172.18.0.49 port 6440 after 0 ms: Connection refused
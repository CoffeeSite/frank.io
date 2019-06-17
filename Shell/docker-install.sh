#!/bin/bash

#stop if exist
service docker stop
  
#remove old docker
yum remove -y docker docker-client docker-client-latest docker-common docker-latest  docker-latest-logrotate  docker-logrotate docker-selinux docker-engine-selinux docker-engine
#remove docker files
rm -rf /var/lib/docker/

#install docker
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-18.03.1.ce

#create default bridge

ip link set eopdocker0 down && ip link del dev eopdocker0
ip link set docker_gwbridge down && ip link del dev docker_gwbridge

yum install -y bridge-utils
#brctl addbr eopdocker0
#ip addr add 192.168.5.1/24 dev eopdocker0 && ip link set dev eopdocker0 up

if [ -d "/etc/docker/daemon.json" ];then
cp -rn /etc/docker/daemon.json /etc/docker/daemon.json.bak
else
  if [ ! -d "/etc/docker/" ];then
  mkdir /etc/docker/
  fi
touch /etc/docker/daemon.json
fi

echo '{"storage-driver": "devicemapper","bip":"182.168.1.5/24","insecure-registries":["1.1.1.1:5000"]}' >> /etc/docker/daemon.json

service docker start

docker network create \
--subnet 10.255.0.0/16 \
--opt com.docker.network.bridge.name=docker_gwbridge \
--opt com.docker.network.bridge.enable_icc=false \
--opt com.docker.network.bridge.enable_ip_masquerade=true \
docker_gwbridge

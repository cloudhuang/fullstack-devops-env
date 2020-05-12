#!/usr/bin/env bash

# Using huaweicloud centos7 mirror
sudo yum -y install wget
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.huaweicloud.com/repository/conf/CentOS-7-anon.repo
sudo yum update

# Install docker-ce
sudo wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.huaweicloud.com/docker-ce/linux/centos/docker-ce.repo
sudo sed -i 's+download.docker.com+mirrors.huaweicloud.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
sudo yum makecache fast
sudo yum -y install docker-ce
sudo usermod -aG docker $(whoami)
sudo newgrp docker
sudo systemctl enable docker
sudo systemctl start docker

# Install K8S
sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.huaweicloud.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.huaweicloud.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.huaweicloud.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

sudo setenforce 0
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
sudo systemctl start kubelet
sudo sysctl net.bridge.bridge-nf-call-iptables=1
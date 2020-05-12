#!/usr/bin/env bash
# Config hosts
sudo cat <<EOF > /etc/hosts
192.168.99.8  master.example.com
192.168.99.9  server1.example.com
192.168.99.10 server2.example.com
EOF

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

# Install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

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

# Cleanup vagrant box - https://stackoverflow.com/questions/35727026/how-to-reduce-the-size-of-vagrant-vm-image
# echo "==> Clean up yum cache of metadata and packages to save space"
# yum -y --enablerepo='*' clean all

# echo "==> Clear core files"
# rm -f /core*

# echo "==> Removing temporary files used to build box"
# rm -rf /tmp/*

# echo '==> Zeroing out empty area to save space in the final image'
# dd if=/dev/zero of=/EMPTY bs=1M
# rm -f /EMPTY
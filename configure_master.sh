#!/bin/bash
ADDRESS="$(ip -4 addr show eth1 | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sudo sed -e "s/^.*master.*/${ADDRESS} master master.local/" -i /etc/hosts

sudo systemctl daemon-reload
sudo kubeadm init --ignore-preflight-errors=all --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=${ADDRESS} --token=a7da6c.4566sfsg56rb3456
sleep 15
sudo mkdir -p /root/.kube/
sudo cp /etc/kubernetes/admin.conf /root/.kube/config
sudo cp /etc/kubernetes/admin.conf /vagrant/

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/default-backend.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/configmap.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/tcp-services-configmap.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/udp-services-configmap.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/with-rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
kubectl proxy &
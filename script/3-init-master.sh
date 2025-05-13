#!/bin/bash
set -e

echo "[1] Init Kubernetes master"
kubeadm init \
  --apiserver-advertise-address=172.30.66.56 \
  --pod-network-cidr=192.168.0.0/16 \
  --upload-certs

echo "[2] Setup kube config"
mkdir -p $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo "[3] Install Calico (network plugin)"
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

echo "✅ Master node is ready."

echo "[*] Get join command below:"
kubeadm token create --print-join-command --ttl 0

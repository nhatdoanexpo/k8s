#!/bin/bash
set -e

echo "[1] Disable swap"
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

echo "[2] Load kernel modules"
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

echo "[3] Set sysctl params"
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

echo "✅ Swap off & kernel modules configured."

#!/bin/bash
set -euxo pipefail

# Update packages
apt-get update

# Install dependencies
apt-get install -y curl git ca-certificates

# Install Docker
curl -fsSL https://get.docker.com | sh

systemctl enable docker
systemctl start docker

# Install K3s
curl -sfL https://get.k3s.io | sh -

# Wait until K3s is ready
until kubectl get nodes >/dev/null 2>&1; do
    sleep 5
done

PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

cp /etc/rancher/k3s/k3s.yaml /tmp/kubeconfig

sed -i "s/127.0.0.1/${PUBLIC_IP}/" /tmp/kubeconfig

aws secretsmanager put-secret-value \
  --secret-id zuri-k3s-kubeconfig \
  --secret-string file:///tmp/kubeconfig


# Create kube directory
mkdir -p /home/ubuntu/.kube

cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
chown -R ubuntu:ubuntu /home/ubuntu/.kube

echo "K3s installation completed"
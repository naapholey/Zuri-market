#!/bin/bash
set -euxo pipefail

apt-get update -y
apt-get install -y curl git ca-certificates

curl -sfL https://get.k3s.io | sh -

# Wait for k3s API to be ready (IMPORTANT)
until kubectl get nodes >/dev/null 2>&1; do
  echo "Waiting for k3s..."
  sleep 5
done

mkdir -p /home/ubuntu/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
chown -R ubuntu:ubuntu /home/ubuntu/.kube
chmod 600 /home/ubuntu/.kube/config

echo "export KUBECONFIG=/home/ubuntu/.kube/config" >> /home/ubuntu/.bashrc

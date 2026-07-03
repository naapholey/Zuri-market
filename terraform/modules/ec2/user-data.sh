 <<-EOF
#!/bin/bash
set -eux

apt-get update

apt-get install -y \
    curl \
    unzip \
    git \
    ca-certificates

curl -fsSL https://get.docker.com | sh

systemctl enable docker
systemctl start docker

curl -sfL https://get.k3s.io | sh -

mkdir -p /home/ubuntu/.kube

cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config

chown -R ubuntu:ubuntu /home/ubuntu/.kube

echo "K3s Installed"
 EOF
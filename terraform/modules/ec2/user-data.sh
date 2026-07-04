 <<-EOF
#!/bin/bash
 exec > /var/log/user_data.log 2>&1
              set -e # Stop the script immediately if any command fails

              echo "=== Starting Kubernetes Installation ==="
apt-get update -y

apt-get install -y \
    curl \
    apt-transport-https \
    gpg \
    unzip \
    git \
    ca-certificates

 swapoff -a
sed -i '/swap/d' /etc/fstab

curl -fsSL https://get.docker.com | sh

systemctl enable docker
systemctl start docker

curl -sfL https://get.k3s.io | sh -

# Wait until K3s is ready
until [ -f /etc/rancher/k3s/k3s.yaml ]; do
  sleep 5
done

# Wait for the API server
until kubectl get nodes >/dev/null 2>&1; do
  sleep 5
done

PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

cp /etc/rancher/k3s/k3s.yaml /tmp/kubeconfig

sed -i "s/127.0.0.1/${PUBLIC_IP}/" /tmp/kubeconfig

aws secretsmanager put-secret-value \
  --secret-id zuri-k3s-kubeconfig \
  --secret-string file:///tmp/kubeconfig

mkdir -p /home/ubuntu/.kube

cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config

chown -R ubuntu:ubuntu /home/ubuntu/.kube

echo "K3s Installed"
 EOF
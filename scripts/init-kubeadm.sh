#!/bin/bash

# Exit on error
set -e

# Install required packages
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Kubernetes apt repository
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
add-apt-repository "deb https://apt.kubernetes.io/ kubernetes-xenial main"

# Install kubeadm, kubelet, and kubectl
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Disable swap
swapoff -a
sed -i '/swap/d' /etc/fstab

# Load required kernel modules
cat > /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Set required sysctl parameters
cat > /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

# Initialize kubeadm (run only on master node)
if [ "$1" == "master" ]; then
    kubeadm init --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12

    # Set up kubectl for the root user
    mkdir -p /root/.kube
    cp -i /etc/kubernetes/admin.conf /root/.kube/config
    chown $(id -u):$(id -g) /root/.kube/config

    # Install Flannel CNI
    kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

    # Generate join command for worker nodes
    kubeadm token create --print-join-command > /root/join-command.sh
    chmod +x /root/join-command.sh
fi

# Print completion message
if [ "$1" == "master" ]; then
    echo "Master node setup complete!"
    echo "Use the following command on worker nodes:"
    cat /root/join-command.sh
else
    echo "Worker node preparation complete!"
    echo "Run the join command from the master node to join the cluster."
fi

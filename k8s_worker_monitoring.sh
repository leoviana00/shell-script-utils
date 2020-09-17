#!/bin/sh
 
# These commands will install the Kubernetes worker components and join an existing cluster.
apt-get update
 
apt-get upgrade -y
 
bash -c 'cat << EOF > /etc/docker/daemon.json
{
   "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF'
 
apt-get install  -y   apt-transport-https     ca-certificates     curl     software-properties-common
 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 
add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
 
apt-get update
 
apt-get install -y docker-ce
 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
 
bash -c 'cat << EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF'
 
apt update
 
apt install -y kubelet kubeadm kubectl
 
 
#### IMPORTANT ###
# Change the command below to use a valid token and IP address for your existing cluster
 
kubeadm join --token 123091.73f18d0e3afcd54b 172.16.16.15:6443 --discovery-token-ca-cert-hash sha256:000ccded7dfae148a89ed2bce9c17f584a7048e2e898da2cc102a11e14334f42
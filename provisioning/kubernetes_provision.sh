#!/bin/bash

# Update package database
sudo apt-get -q -y update

# Update ca-certificates
sudo update-ca-certificates

# Install microk8s, snap, and add user permissions
sudo snap install microk8s --classic && \
  sudo snap install helm --classic && \
  microk8s.enable dns dashboard registry

sudo usermod -a -G microk8s vagrant

# get auto-generated access token for k8s dashboard
token=$(microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
echo "================================================"
echo "ACCESS TOKEN FOR KUBERNETES DASHBOARD:"
echo $(microk8s.kubectl -n kube-system describe secret $token)
echo "================================================"

# create alias for microk8s commands
echo "alias kubectl='microk8s.kubectl'" >> /home/vagrant/.bash_aliases

# update .kube/config file
sudo microk8s.kubectl config view --raw > $HOME/.kube/config


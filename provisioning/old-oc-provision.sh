#!/bin/bash

sudo apt-get -y update

# download minishift binary
wget https://github.com/minishift/minishift/releases/download/v1.33.0/minishift-1.33.0-linux-amd64.tgz
tar xvf minishift-1.33.0-linux-amd64.tgz
mv /home/vagrant/home/vagrant/minishift-1.33.0-linux-amd64/minishift /usr/local/bin/


# install virtualbox
sudo apt install -y virtualbox 


# set GITHUB API TOKEN to circumvent GitHub API rate limiting
export MINISHIFT_GITHUB_API_TOKEN=b7870ce1c72113afeeeb2aa4b5229f43c71f25f9


# install libvirt and qemu-kvm 
sudo apt install -y libvirt-bin qemu-kvm
sudo usermod -a -G libvirtd $(whoami)

sudo curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-ubuntu16.04 \
  -o /usr/local/bin/docker-machine-driver-kvm

sudo chmod +x /usr/local/bin/docker-machine-driver-kvm
sudo systemctl start libvirtd


# Start Minishift
minishift start


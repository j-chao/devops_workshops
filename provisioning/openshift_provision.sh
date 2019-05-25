#!/bin/bash

# Update package database
sudo apt-get -q -y update

# Download OpenShift Origin package
wget -q https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar -zvxf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

# Copy 'oc' & 'kubectl' commands to bin directory
sudo cp /home/vagrant/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin/
sudo cp /home/vagrant/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/kubectl /usr/local/bin/

# Cleanup training space
rm -rf /home/vagrant/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit
rm openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

# Add insecure registries to docker daemon 
sudo echo '{ "insecure-registries" : [ "172.30.0.0/16", "docker-registry-default.172.28.33.20.nip.io", "docker-registry-default.172.28.33.20.nip.io:80" ] }' | sudo tee -a /etc/docker/daemon.json

# Restart docker service
sudo service docker restart

# Disable firewall
sudo ufw disable

# Start up OpenShift cluster
oc cluster up --public-hostname=172.28.33.20

# Expose OpenShift integrated docker registry
oc login -u system:admin
oc expose svc docker-registry -n default
oc login -u developer

# Download docker-compose binary
sudo curl -s -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

# Make docker-compose executable
sudo chmod +x /usr/local/bin/docker-compose


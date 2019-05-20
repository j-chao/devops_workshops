#!/bin/bash

# update package database
sudo apt-get -q -y update

# download OpenShift Origin package
wget -q https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar -zvxf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

# copy 'oc' command to bin directory
sudo cp /home/vagrant/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin/

# add insecure registries to docker daemon 
sudo echo '{ "insecure-registries" : [ "172.30.0.0/16", "docker-registry-default.172.28.33.20.nip.io", "docker-registry-default.172.28.33.20.nip.io:80" ] }' | sudo tee -a /etc/docker/daemon.json

# restart docker service
sudo service docker restart

# disable firewall
sudo ufw disable

# start up OpenShift cluster
oc cluster up --public-hostname=172.28.33.20

# expose OpenShift integrated docker registry
#oc login -u system:admin
#oc expose svc docker-registry -n default

# download docker-compose binary
sudo curl -s -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose


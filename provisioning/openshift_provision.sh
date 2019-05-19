#!/bin/bash

sudo apt-get -y update

# download OpenShift Origin package
wget -q https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar -zvxf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

# copy 'oc' command to bin directory
sudo cp /home/vagrant/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin/

# add insecure registry to docker daemon 
#cat << EOF > /etc/docker/daemon.json 
#{ "insecure-registries" : [ "172.30.0.0/16"  ] 
#}
#EOF

sudo echo '{ "insecure-registries" : [ "172.30.0.0/16" ] }' | sudo tee -a /etc/docker/daemon.json

# restart docker service
sudo service docker restart


# disable firewall
sudo ufw disable

# start up OpenShift cluster
oc cluster up --public-hostname=172.28.33.11



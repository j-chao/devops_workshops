#!/bin/bash

# Disable firewall
sudo ufw disable

# Download OpenShift Origin package
wget -q https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar -zvxf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

# Copy 'oc' command to bin directory
sudo cp /home/vagrant/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin/

# Add insecure registries to docker daemon 
sudo echo '{ "insecure-registries" : [ "172.30.0.0/16", "docker-registry-default.172.28.33.20.nip.io", "docker-registry-default.172.28.33.20.nip.io:80" ] }' | sudo tee -a /etc/docker/daemon.json

# Restart docker service
sudo service docker restart

# Add Jenkins apt repository
wget -qq -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb [trusted=yes] https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update package database
sudo apt-get -q -y update 

# Install Jenkins
sudo apt-get -q -y install default-jre=2:1.8-56ubuntu2
sudo apt-get -q -y install jenkins=2.164.3

# Add jenkins user to docker group
sudo usermod -aG docker jenkins

# Disable Jenkins initial setup wizard
sudo sed -i 's/^.*java.awt.*$/JAVA_ARGS="-Djava.awt.headless=true, -Djenkins.install.runSetupWizard=false"/' /etc/default/jenkins

# Create Jenkins init directory
sudo mkdir -p /var/lib/jenkins/init.groovy.d

# Copy Jenkins init scripts to Jenkins init directory
sudo cp /home/vagrant/jenkins_init/* /var/lib/jenkins/init.groovy.d/

# Restart Jenkins
sudo systemctl restart jenkins


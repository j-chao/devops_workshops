#!/bin/bash

# Disable firewall
sudo ufw disable

# Add Jenkins apt repository
wget -qq -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update package database
sudo apt-get -qq update --fix-missing

# Create Jenkins init directory
sudo mkdir -p /var/lib/jenkins/init.groovy.d

# Copy Jenkins init script to Jenkins init directory
sudo cp ~/jenkins_init.groovy /var/lib/jenkins/init.groovy.d/jenkins_init.groovy

# Install Jenkins
sudo apt-get -qq install default-jre=2:1.8-56ubuntu2
sudo apt-get -qq install jenkins=2.164.3

# Add jenkins user to docker group
sudo usermod -aG docker jenkins

# Disable Jenkins initial setup wizard
sudo sed -i 's/^.*java.awt.*$/JAVA_ARGS="-Djava.awt.headless=true, -Djenkins.install.runSetupWizard=false"/' /etc/default/jenkins

# Restart Jenkins
sudo systemctl restart jenkins


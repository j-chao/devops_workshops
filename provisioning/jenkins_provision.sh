#!/bin/bash

# disable firewall
sudo ufw disable

# Install Jenkins
sudo apt-get -y update
#wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
#sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get -y install default-jre
sudo apt-get -y install jenkins


#!/bin/bash

# Disable firewall
sudo ufw disable

# Add Jenkins apt repository
wget -qq -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update package database
sudo apt-get -qq update

# Install Jenkins
sudo apt-get -qq install default-jre=2:1.8-56ubuntu2
sudo apt-get -qq install jenkins=2.164.3

# Bootstrap Jenkins instance
sudo mkdir -p /var/lib/jenkins/init.groovy.d
cat << EOF | sudo tee -a /var/lib/jenkins/init.groovy.d/basic-security.groovy
#!groovy

import jenkins.model.*
import hudson.util.*;
import jenkins.install.*;

def instance = Jenkins.getInstance()

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

jenkins.setSystemMessage("Jenkins Training Environment for DevOps Workshop.")
jenkins.disableSecurity()

urlConfig = JenkinsLocationConfiguration.get()
urlConfig.setUrl("172.28.33.30:8080")
urlConfig.save()

def ams = instance.getActiveAdministrativeMonitors()
for (AdministrativeMonitor am : ams) {
  am.disable(true) 
}

EOF

# Disable setup wizard
sudo sed -i 's/^.*java.awt.*$/JAVA_ARGS="-Djava.awt.headless=true, -Djenkins.install.runSetupWizard=false"/' /etc/default/jenkins


#cat << EOF | sudo tee -a /var/lib/jenkins/init.groovy.d/basic-security.groovy
##!groovy

#import jenkins.model.*
#import hudson.security.*

#def instance = Jenkins.getInstance()

#def hudsonRealm = new HudsonPrivateSecurityRealm(false)

#hudsonRealm.createAccount("admin","password")
#instance.setSecurityRealm(hudsonRealm)
#instance.save()


# Disable login page for Jenkins
#sudo sed -i.bak '5i\
  #<useSecurity>false</useSecurity>' \
  #/var/lib/jenkins/config.xml

#sudo sed -i 's/^.*useSecurity.*$/  <useSecurity>false<\/useSecurity>/' /var/lib/jenkins/config.xml
#sudo systemctl restart jenkins

# Disable setup wizard



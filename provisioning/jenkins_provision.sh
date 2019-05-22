#!/bin/bash

# Disable firewall
sudo ufw disable

# Add Jenkins apt repository
wget -qq -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update package database
sudo apt-get -qq update --fix-missing

# Install Jenkins
sudo apt-get -qq install default-jre=2:1.8-56ubuntu2
sudo apt-get -qq install jenkins=2.164.3a

# Add jenkins user to docker group
sudo usermod -aG docker jenkins

# Disable setup wizard
sudo sed -i 's/^.*java.awt.*$/JAVA_ARGS="-Djava.awt.headless=true, -Djenkins.install.runSetupWizard=false"/' /etc/default/jenkins

# Bootstrap Jenkins instance
sudo mkdir -p /var/lib/jenkins/init.groovy.d
cat << EOF | sudo tee -a /var/lib/jenkins/init.groovy.d/training_init.groovy
#!groovy

import hudson.util.*
import hudson.model.*
import hudson.plugins.git.*
import jenkins.model.*
import jenkins.install.*

def instance = Jenkins.getInstance()
def installed = false
def initialized = false
def pluginParameter="git workflow-aggregator blueocean"
def plugins = pluginParameter.split()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

instance.setSystemMessage("Jenkins Training Environment for DevOps Workshop.")
instance.disableSecurity()
instance.save()

urlConfig = JenkinsLocationConfiguration.get()
urlConfig.setUrl("http://172.28.33.30:8080")
urlConfig.save()

def ams = instance.getActiveAdministrativeMonitors()
for (AdministrativeMonitor am : ams) {
  am.disable(true) 
}

plugins.each {
  if (!pm.getPlugin(it)) {
    if (!initialized) {
      uc.updateAllSites()
      initialized = true
    }
    def plugin = uc.getPlugin(it)
    if (plugin) {
    	def installFuture = plugin.deploy()
      while(!installFuture.isDone()) {
        sleep(3000)
      }
      installed = true
    }
  }
}
if (installed) {
  instance.save()
  instance.restart()
}



def scm = new GitSCM("git@github.com:dermeister0/Tests.git")
scm.branches = [new BranchSpec("*/develop")];

def flowDefinition = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, "Jenkinsfile")

def parent = Jenkins.instance
def job = new org.jenkinsci.plugins.workflow.job.WorkflowJob(parent, "New Job")
job.definition = flowDefinition

parent.reload()

EOF



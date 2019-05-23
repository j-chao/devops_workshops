#!groovy
// Jenkins initial setup script for DevOps training workshop

import hudson.*
import hudson.util.*
import hudson.model.*
import hudson.plugins.git.*
import jenkins.*
import jenkins.model.*
import jenkins.install.*

def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()
def ams = instance.getActiveAdministrativeMonitors()
def installed = false
def initialized = false
def pluginParameter="git workflow-aggregator blueocean"
def plugins = pluginParameter.split()

// Set Jenkins current install state to completed
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

// Set Jenkins instance description
instance.setSystemMessage("Jenkins Training Environment for DevOps Workshop.")

// Disable security
instance.disableSecurity()

instance.save()

// Set Jenkins Root URL to Vagrant VM private IP
urlConfig = JenkinsLocationConfiguration.get()
urlConfig.setUrl("http://172.28.33.30:8080")
urlConfig.save()

// install Jenkins plugins, and restart Jenkins
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

//// create example Jenkins pipeline job
//def scm = new GitSCM("git@github.com:dermeister0/Tests.git")
//scm.branches = [new BranchSpec("*/develop")];

//def flowDefinition = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, "Jenkinsfile")

//def parent = Jenkins.instance
//def job = new org.jenkinsci.plugins.workflow.job.WorkflowJob(parent, "New Job")
//job.definition = flowDefinition

//parent.reload()

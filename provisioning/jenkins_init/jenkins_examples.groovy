#!groovy
// Jenkins example jobs

import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*
import java.io.*
import java.nio.charset.StandardCharsets
import javax.xml.transform.stream.*


// Example Jenkins freestyle job
config = """
<project>
<description></description>
<keepDependencies>false</keepDependencies>
<properties>
<hudson.plugins.jira.JiraProjectProperty plugin="jira@3.0.7"/>
</properties>
<scm class="hudson.scm.NullSCM"/>
<canRoam>true</canRoam>
<disabled>false</disabled>
<blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
<blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
<triggers/>
<concurrentBuild>false</concurrentBuild>
<builders>
<hudson.tasks.Shell>
<command>ls</command>
</hudson.tasks.Shell>
</builders>
<publishers/>
<buildWrappers/>
</project>
"""

InputStream stream = new ByteArrayInputStream(config.getBytes(StandardCharsets.UTF_8));
job = Jenkins.getInstance().getItemByFullName("job_name", AbstractItem)

if (job == null) {
  println "Constructing job"
  Jenkins.getInstance().createProjectFromXML("job_name", stream);
}
else {
  println "Updating job"
  job.updateByXml(new StreamSource(stream));
}


// Example Jenkins pipeline job

// create example Jenkins pipeline job
//def scm = new GitSCM("git@github.com:dermeister0/Tests.git")
//scm.branches = [new BranchSpec("*/develop")];

//def flowDefinition = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, "Jenkinsfile")

//def parent = Jenkins.instance
//def job = new org.jenkinsci.plugins.workflow.job.WorkflowJob(parent, "New Job")
//job.definition = flowDefinition

//parent.reload()


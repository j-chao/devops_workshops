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
  <actions/>
  <description>This is an example freestyle-type Jenkins job that does the following:&#xd;
- pull source code from a GitHub repo&#xd;
- build the Docker image&#xd;
- push the Docker image to an OpenShift integrated repository</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <hudson.plugins.jira.JiraProjectProperty plugin="jira@3.0.7"/>
  </properties>
  <scm class="hudson.plugins.git.GitSCM" plugin="git@3.10.0">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <url>https://github.com/datawire/hello-world.git</url>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>*/master</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions/>
  </scm>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command># Build the Docker image
docker build -t hello-world:latest .

# Tag the image for pushing to a repository
docker tag hello-world:latest docker-registry-default.172.28.33.20.nip.io:80/myproject/hello-world:1.0.0

# Login to OpenShift server to obtain credentials token for the integrated repository
oc login 172.28.33.20:8443 -u developer -p anyvalue --insecure-skip-tls-verify=true

# Login to the integrated repository with OpenShift token
docker login docker-registry-default.172.28.33.20.nip.io:80 -u developer -p $(oc whoami -t)

# Push image to the repository
docker push docker-registry-default.172.28.33.20.nip.io:80/myproject/hello-world:1.0.0

</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>
"""

InputStream stream = new ByteArrayInputStream(config.getBytes(StandardCharsets.UTF_8));
job = Jenkins.getInstance().getItemByFullName("freestyle_example", AbstractItem)

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


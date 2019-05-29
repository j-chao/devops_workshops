# DevOps Workshop

<img src="docs/images/jenkins_JCasC.png" width="250">

## Workshop Goals

Participants will understand fundamentally, the culture and goals of DevOps.

They will also learn how to develop and operationalize modern, 
cloud-native applications with tools such as Docker, Kubernetes, OpenShift, and Jenkins.

Participants will leave with the foundational skills necessary to 
containerize, deploy, orchestrate, and maintain applications in the cloud.


## Workshop Format
This workshop is structured into 4 different components, where each component will build off of knowledge learned in previous ones:
- Containers
- Container Orchestration
- Pipelines
- Everything as Code

### Presentation Slides
The presentation slides can be found in the docs/ directory.  
The slides are also published via GitHub Pages at:   
https://github.optum.com/pages/team-cumulus/devops_workshops


## Pre-requistes
This workshop should be compatible for users with Mac as well as Windows machines, 
as long as the pre-reqs below are met, however, only Mac machines have been tested.


- Familiarity with using the Terminal in a Linux environment.   
(Or willingness to learn!)
- Git installed on your local machine.  
(If you don't have Git installed, you can download a ZIP of this repository instead.)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installed on your local machine.   
(You can request for VirtualBox on the [AppStore](http://appstore.uhc.com/AppInfo/AppVersionId/18189?BackToList=/AppList/AppList))
- [Vagrant](https://www.vagrantup.com/docs/installation/) installed on your local machine.   
(Also available on the [AppStore](http://appstore.uhc.com/AppInfo/AppVersionId/15331?BackToList=/AppList/AppList))

If you are on a Mac, you can use [homebrew](https://brew.sh/) to install the pre-reqs:
```bash
$ brew cask install virtualbox
$ brew cask install vagrant
```

#### Enabling admin access for your Mac machine
You may wish to install the pre-requisites above yourself, instead of through the AppStore.  
Some installations will require elevated admin privileges to complete.  

To request for local workstation admin rights for your Mac, follow the instructions 
[here](https://helpdesk.uhg.com/knowledge-center/personal-hardware-software/general-applications/mac-computer/181051).

Once approved, you will then be able to enable local admin access for your Mac machine via 
the Self Service desktop application for up to 4 hours at a time.


### Setting up the training environment
Clone the repo and the git submodules, and navigate to the repo's root directory:
```bash
$ git clone --recurse-submodules https://github.optum.com/team-cumulus/devops_workshops.git
$ cd devops_workshops
```

Start up the virtual machines using Vagrant:  
```bash
$ vagrant up
```
Note: This step may take a while, especially the openshift VM.

This will start up an 3 virtual machines on your local machine, on a private network:  

hostname  | private IP
---       | ---
docker    | 172.28.33.10
openshift | 172.28.33.20
jenkins   | 172.28.33.30


You can also specify the VMs you want to start up, for example:
```bash
$ vagrant up docker openshift
```


You can view the virtual machines with the following command:
```bash
$ vagrant global-status --prune
```

You should see output similar to the following:
```
id       name      provider   state   directory
--------------------------------------------------------------------
3f10a34  docker    virtualbox running /Users/<MSID>/devops_workshops
62a885e  openshift virtualbox running /Users/<MSID>/devops_workshops
6dfd328  jenkins   virtualbox running /Users/<MSID>/devops_workshops
```

### Resetting the training environment
Anytime you want to reset the training environment to its original state, run this command:

```bash
$ vagrant halt; vagrant destroy -f; vagrant up
```

### Stopping the training environment
To stop the virtual machines you can either suspend them:

```bash
$ vagrant suspend
```

or halt them:
```bash
$ vagrant halt
```


## Contributors
[Justin Chao](mailto:justin.chao@optum.com)


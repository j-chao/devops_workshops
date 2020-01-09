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
- Container Orchestration (Openshift, Kubernetes)
- Pipelines
- Everything as Code

The instructions for each workshop component can be found in their respective directories of this repo.


### Presentation Slides
The presentation slides can be found in the docs/ directory.  


## Pre-requistes
This workshop should be compatible for users with Mac as well as Windows machines, 
as long as the pre-reqs below are met, however, only Mac machines have been tested.


- Familiarity with using the Terminal in a Linux environment.   
(Or willingness to learn!)
- Git installed on your local machine.  
(If you don't have Git installed, you can download a ZIP of this repository instead.)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 6.0.10 installed on your local machine.   
- [Vagrant](https://www.vagrantup.com/docs/installation/) 2.2.4 installed on your local machine.   
- Local Admin Access 

If you are on a Mac, you can use [homebrew](https://brew.sh/) to install the pre-reqs:
```bash
$ brew cask install virtualbox
$ brew cask install vagrant
```

## Setting up the training environments
Clone the repo and the git submodules, and navigate to the repo's root directory:
```bash
$ git clone --recurse-submodules << this GitHub repository >>
$ cd devops_workshops
```

If you are on the corporate network, be sure to download the necessary CA certificates:
```bash
$ provisioning/optum_certs/download_certificates.sh
```

Start up the necessary virtual machine(s) using Vagrant.
```bash
$ vagrant up <vm name>
```
Note: This step may take a while, especially the openshift VM.

This will start up the virtual machine(s) on your local machine, on a private network:  

hostname   | private IP
---        | ---
docker     | 172.28.33.10
openshift  | 172.28.33.20
kubernetes | 172.28.33.40
jenkins    | 172.28.33.30

You can also start up multiple VM if you need to:
```bash
$ vagrant up docker openshift
```

It is highly recommended that you only start up only the virtual machines that are required for each workshop component,    
rather than trying to start up all the virtual machines for all workshop components.  
This will help prevent unnecessary resource consumption from your host machine.

You can view the provisioned virtual machines with the following command:
```bash
$ vagrant global-status --prune
```

You should see output similar to the following:
```
id       name       provider   state   directory
-----------------------------------------------------------------
3f10a34  docker     virtualbox running /Users/<MSID>/devops_workshops
62a885e  openshift  virtualbox running /Users/<MSID>/devops_workshops
6dfd328  jenkins    virtualbox running /Users/<MSID>/devops_workshops
609159a  kubernetes virtualbox running /Users/<MSID>/devops_workshops
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


## Maintainer
[Justin Chao](mailto:justin.chao@optum.com)


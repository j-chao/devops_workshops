# DevOps Workshop

## Workshop Format
This workshop is structured into 4 different components, where each component will build off of knowledge learned in previous ones:
- Containers
- Container Orchestration
- Pipelines
- Everything as Code

The presentation slides can be found in the slides/ directory.

## Pre-requistes
- Familiarity with using the Terminal in a Linux environment. (Or willingness to learn!)
- Git installed on your local machine.
- VirtualBox installed on your local machine. (You can request for VirtualBox on the [AppStore](appstore.uhc.com))
- [Vagrant](https://www.vagrantup.com/docs/installation/) installed on your local machine.


## Getting Started
### Setting up the training environment
Clone the repo and navigate to the repo's root directory:
```bash
$ git clone https://github.optum.com/team-cumulus/devops_workshops.git
$ cd devops_workshops
```

Start up the virtual machines using Vagrant:
```bash
$ vagrant up
```

This will start up an 3 virtual machines on your local machine, on a private network:

hostname  | private IP
---       | ---
docker    | 172.28.33.10
openshift | 172.28.33.11
jenkins   | 172.28.33.12


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


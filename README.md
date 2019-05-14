# DevOps Workshop

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

This will start up an 3 virtual machines on your local machine:

hostname  | private IP
---       | ---
local     | 172.28.33.11
openshift | 172.28.33.12
jenkins   | 172.28.33.13


You can view the virtual machines with the following command:
```bash
$ vagrant global-status --prune
```

You should see output similar to the following:
```
id       name      provider   state   directory
--------------------------------------------------------------------
3f10a34  local     virtualbox running /Users/<MSID>/devops_workshops
62a885e  openshift virtualbox running /Users/<MSID>/devops_workshops
6dfd328  jenkins   virtualbox running /Users/<MSID>/devops_workshops
```

### Resetting the training environment
Anytime you want to reset the training environment to its original state, run this command:

```bash
$ vagrant halt ; vagrant destroy -f ; vagrant up
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


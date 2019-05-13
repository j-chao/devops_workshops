# DevOps Workshop

## Containers

Containers

## Pre-requistes
- Familiarity with using the Terminal
- VirtualBox installed
- Vagrant installed


## Getting Started

```bash
vagrant up
```


```vagrant up```

It will take a few minutes to setup the five servers. This includes an HAProxy load balancer, three Apache webservers, and a utility server to run a load testing tool against the load balancer. The load balancer is reachable at http://localhost:8081. Try the URL and refresh a few times. You should see a different result each time. 

## Resetting the environment

Anytime you want to reset the environment to its original state, run this command:

```vagrant halt;vagrant destroy -f;vagrant up```

## Stopping the environment

To stop the virtual machines you can either suspend them:

```vagrant suspend```

or halt them:

```vagrant halt```


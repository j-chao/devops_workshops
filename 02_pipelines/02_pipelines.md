# Continuous Integration & Continuous Deployment Pipelines

<img src="images/jenkins.png" width="250">

## Working with Jenkins

To start, ensure that both the `jenkins` and `openshift` VMs are running on your local machine:
```bash
$ vagrant global-status --prune
```
You should see output similar to:
```
id       name      provider   state   directory
--------------------------------------------------------------------
2c97819  jenkins   virtualbox running /Users/<MSID>/devops_workshops
b2ca4f7  openshift virtualbox running /Users/<MSID>/devops_workshops
```

Navigate to the Jenkins UI at `https://172.28.33.20:8443/console/` in a web browser on your local machine.

Login to OpenShift as a developer with the following credentials:
```bash
Username: developer
Password: <any value>
```

In another browser window, navigate to the Jenkins UI at `https://172.28.33.30:8080` on your local machine.
It may take a while for Jenkins to fully initialize.


### Creating Jenkins Jobs

Once Jenkins is ready, the first page you'll see should look like the following:






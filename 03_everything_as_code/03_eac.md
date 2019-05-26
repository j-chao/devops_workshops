# Everything as Code

<img src="images/jenkins.png" width="150">

To start, ensure that the `openshift` VM is running on your local machine:
```bash
$ vagrant global-status --prune
```
You should see output similar to:
```sh
id       name      provider   state   directory
--------------------------------------------------------------------
4c56060  openshift virtualbox running /Users/<MSID>/devops_workshops
```

Navigate to the OpenShift UI at `https://172.28.33.20:8443/console/` in a web browser on your local machine.

Login as a developer with the following credentials:
```sh
Username: developer
Password: <any value>
```

Also, ssh into the `openshift` VM, so we can make use of the `oc` CLI:
```bash
$ vagrant ssh openshift
```

### Working with OpenShift & Kubernetes YAML Definitions

Recall the steps taken to deploy an image to OpenShift.  

While executing `$ oc new-app` may seem relatively simple, the task for creating, deploying, 
and managing applications become much more tedius as the number of application components scale.

It becomes much more complex of a task when you begin implementing readiness & liveliness probes, init containers, 
auto-scaling with cpu and memory resource limits,
and configuring secrets, configmaps, ingress controllers, TLS-secured routes, and environment variables per different environments.

Fortunately, in the same way that we're able to define our pipelines as code with Jenkinsfiles,
we can define our Kubernetes and OpenShift resources as code in the form of YAML files.

Having all of our containerization strategies, deployment configurations, pipeline configurations, and infrastructure as
code helps us ensure that our infrastructure is immutable and repeatable.  
This helps us reduce risk for when deployments are done to higher environments, and to production.

With our resources defined as YAML files, we can apply the configurations defined using `$ oc apply`:

```bash
$ oc apply -f <resource.yaml or directory containing multiple YAML files>
```

Let's deploy the example flask_app application from the first workshop, using YAML definitions.
First, make sure that the flask_app image is available in the integrated OpenShift repository!  
```bash
$ docker build -t docker-registry-default.172.28.33.20.nip.io:80/myproject/flask-app:1.0.0 flask_app/
$ docker push docker-registry-default.172.28.33.20.nip.io:80/myproject/flask-app:1.0.0
```

Now, create the application using the example YAML definitions files in the openshift_yaml_files/ directory:
```bash
$ oc apply -f flask_app/openshift_yaml_files/
```

Now navigate to the OpenShift console, and watch the magic unfurl - it's so easy!

Be sure to go back and look at the example YAML definition files, so you can understand how they're structured.  
In the flask_app/openshift_yaml_files/ directory, you should find 3 YAML files specifying 3 OpenShift resources:
- DeploymentConfig
- Service
- Route



### Creating Your Own YAML files

Try creating and then applying YAML files that define the resources necessary for deploying
the Docker images for the example flask + NGINX multi-container application.

Is it possible to deploy both containers in a single Pod?





If you want to write these in a text editor or IDE of your choice on your local host machine, 
instead of through a text editor via the terminal on the guest `openshift` VM, 
you can copy your files over to the `openshift VM` using `$ vagrant scp`:

```bash
$ vagrant scp  <file | -r directory> vagrant@172.28.33.20:/home/vagrant/
```

Or, if you have the `oc` CLI installed on your local host machine,
be sure to login to the OpenShift server, `$ oc login 172.28.33.20:8443`, in order to `$ oc apply` your files!



### Using Kompose



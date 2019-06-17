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

Navigate to the OpenShift UI at `https://openshift-vm:8443/console/` in a web browser on your local machine.

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
$ docker build -t docker-registry-default.openshift-vm.nip.io:80/myproject/flask-app:1.0.0 flask_app/
$ docker push docker-registry-default.openshift-vm.nip.io:80/myproject/flask-app:1.0.0
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



### Creating Your Own YAML Definition Files using Kompose

For the flask + NGINX multi-container applitaion, we could go through and write line-by-line, all the YAML definitions
necessary to deploy the application, but that's annoying.   

Fortunately, there's a smarter way to do so, by using an open-source tool called [Kompose](http://kompose.io/)!  
Kompose is a tool that helps users familiar with docker-compose move to Kubernetes.   
It takes a docker-compose.yml file and translates it into Kubernetes resources.
It also builds the images and pushes them to the defined repository for you.  *Amazing*.

To get started, let's first login to the integrated OpenShift repository, so that kompose can push our images.
```bash
$ docker login -u developer -p $(oc whoami -t) docker-registry-default.openshift-vm.nip.io:80
```

Don't forget to replace the service name for the flask application in the NGINX conf file!
```bash
$ sed -i 's/flask/webapp-flask.myproject.svc/g' nginx/app.conf
```

Next, there are a few things that we need to change in our docker-compose.yml file 
for kompose to work the way we want it to:
```Dockerfile
version: '3'
services:
  webapp-flask:
    image: docker-registry-default.openshift-vm.nip.io:80/myproject/webapp-flask:1.0.0
    build:
      context: ./flask
      dockerfile: Dockerfile-flask
    ports:
      - 5000:5000
    environment:
    - MY_ENV_VAR="Hello beautiful environment!"

  webapp-nginx:
    image: docker-registry-default.openshift-vm.nip.io:80/myproject/webapp-nginx:1.0.0
    build:
      context: ./nginx
      dockerfile: Dockerfile-nginx
    ports:
      - 5000:8082
    depends_on:
      - flask
```

Now, let's go ahead and have kompose build & push our images, and convert the docker-compose.yml file 
for the flask + NGINX application into OpenShift YAML resource definitions:
```bash
$ cd flask_nginx
$ kompose convert -f docker-compose.yml --provider openshift --deployment-config -o openshift_deployment.yaml --build local
```

Finally, create the resources per the generated YAML definitions!
```bash
$ oc apply -f openshift_deployment.yaml
```
Finish with exposing the NGINX service with a route:
```bash
$ oc expose svc webapp-nginx --port=8082
```

Kompose is a great tool for bootstrapping your OpenShift and Kubernetes YAML definitions.  
However, when it comes to more advanced configurations, there are still some things that kompose doesn't fully support yet.

Eventually, you'll want to take the generated YAML files and modify them so that they can accomodate 
any other Openshift/Kuberentes configurations that your application requires. 

Understanding how Kubernetes YAML definitions are structured, will also prepare you for advanced topics such as
using and creating [Operators](https://coreos.com/operators/), which are k8s-native Custom Resource Definitions that
allow you to manage domain and operational knowledge of an application as code.

Try configuring a ConfigMap resource using YAML definition files that is then used by the 
webapp-flask application via a mounted volume, for configuring the uWSGI server.

Can you have both containers running in the same Pod resource?


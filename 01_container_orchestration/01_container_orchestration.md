# Container Orchestration 

## Working with OpenShift
To start, ensure that the `openshift` VM is running on your local machine:
```bash
vagrant global-status --prune
```
You should see output similar to:
```sh
id       name      provider   state   directory
--------------------------------------------------------------------
4c56060  openshift virtualbox running /Users/<MSID>/devops_workshops
```

Navigate to the OpenShift UI at `https://172.28.33.11:8443/console/` in a web browser on your local machine.

Login as a developer with the following credentials:
```bash
Username: developer
Password: <any value>
```


### Using Projects & Namespaces
OpenShift Projects are the equivalent of Kubernetes namespaces.
Projects/Namespaces provide a logical way to divide cluster resources between multiple users/teams/environments.
They allow you to organize and manage your content.

To start, create a new project and name it "my-project":  
When you first login, you should see an initial developer project 
called "My Project" created for you on the right side.


### Creating an Application

The first page you'll see when you login is the OpenShift Catalog, 
where the good folks at Red Hat have create a few starter applications 
that can be deployed to OpenShift with minimal mess from you, the end-user.

Let's try deploying the NGINX HTTP server that is already provided for in the Catalog.


<img src="images/catalog_nginx.png" width="500">

Use version "1.12 - latest", name your application "my-nginx", 
and use "https://github.com/sclorg/nginx-ex.git" as the Git repo.

<img src="images/catalog_nginx_config.png" width="500">

Then click "Create".

Once the application is created, navigate to the "Overview" page of your project.

<img src="images/overview.png" width="500">

You should see that the NGINX application has been created.

Go ahead and navigate to the route that was generated for the deployed NGINX application:
`http://my-nginx-myproject.172.28.33.20.nip.io/` 

You should see a "Welcome to Openshift" page.


#### Breaking it Down
As you can see, OpenShift makes it relatively easy to quickly deploy applications as containers,
but there's actually a lot that's going on here.

1. OpenShift first clones the repo where the source code is, and then 
[builds](https://172.28.33.20:8443/console/project/myproject/browse/builds) an image.
There are a number of 
[build strategies](https://docs.openshift.com/container-platform/3.9/architecture/core_concepts/builds_and_image_streams.html#builds)
that can be used here. In this case, we are using a "Source-to-Image (S2I)" build strategy.  
We won't go into the details on the differences between them all, as that is outside the scope of this workshop,
but just know that the idea is the same as `docker build`.

2. The built image is then pushed to a repository.   
This can be any repository we choose (hub.docker.com, docker.optum.com, Nexus, JFrog Artifactory, etc.).   
In this case, OpenShift has an integrated repository that is being hosted internally to the cluster at `172.30.1.1:5000`,
that we will use.  
(If you don't believe me, ssh into the openshift VM and list the running Docker containers :wink: )

3. An "[Image Stream](https://172.28.33.20:8443/console/project/myproject/browse/images)" object is created,
 which provides an abstraction for referencing Docker images from within OpenShift.
This allows other OpenShift objects to automatically perform actions based on changes to Docker images, such as
triggering a new deployment update or build. 
Note: "Image Streams" are unique to OpenShift, and are not supported in default Kubernetes.

4. A "[Deployment Configuration](https://172.28.33.20:8443/console/project/myproject/browse/dc/my-nginx?tab=history)" 
object is created, which details how the application should be deployed and managed. 
(ie: number of replicas, readiness/liveliness probes, ports to be exposed, env variables, image to be deployed, etc.)  
Note: "Deployment Configurations" are unique to OpenShift, and are not supported in default Kubernetes. 
They allow for a greater level of control in configuring and maintaining deployments, 
such as image change deployment triggers, vs. the "Deployment" object in default K8s.

5. According to the Deployment Configuration created, the requested number of 
[Pods](https://172.28.33.20:8443/console/project/myproject/browse/pods) are created.

6. A [Service](https://172.28.33.20:8443/console/project/myproject/browse/services/my-nginx?tab=details) 
object is also created for routing traffic internal to the cluster.

7. A [Route](https://172.28.33.20:8443/console/project/myproject/browse/routes/my-nginx) 
object is created for routing traffic external to the cluster. 
This is the endpoint that allows us to visit the "Welcome to Openshift" page from our web browser.


Take some time and familiarize yourself with the OpenShift console.   
View the logs and events pages and see if you can follow the many different steps involved in deploying a containerized
application on OpenShift.

### Horizontally Scaling your Application

Try scaling the NGINX application to 3 pods.

<img src="images/scale_pods.png" width="500">


### Using the CLI to Manage Resources

Eventually, you will want to get to the point where you can automate your deployments and OpenShift objects 
using scripts and the CLI.

SSH into the openshift VM and login as a developer:
```bash
$ vagrant ssh openshift
$ oc login -u developer
```

Run `oc get all` to view the resources currently running in your project.

Let's take a close look at the deployment config for the NGINX application:
```bash
$ oc describe dc my-nginx
```
Try "describing" other OpenShift objects.

OpenShift objects are defined as yaml files.
Try taking a look at the yaml file specification for the NGINX deployment config:
```bash
$ oc get dc my-nginx -o yaml
```

You can also view the logs from pods via the CLI:
```bash
$ oc logs -f <pod name>
```

You can also edit any resources directly from the CLI as well.  
Try changing the number of "replicas" for the NGINX application to 2.  
```bash
$ oc edit dc my-nginx
```

We will explore the use of yaml template files more in the next workshop on pipelines.


### Deploying Your Own Application 

Let's deploy the exaample flask + NGINX multi-container application from the previous workshop.

##### Build the images

```bash
$ cd flask_nginx/
$ docker-compose build 
```
You should now have two images built locally, named "webapp-flask" and "webapp-nginx".

##### Push the images to the OpenShift integrated Docker repository

For convenience, the integrated repository has been exposed via a route 
that can be accssible from outside the cluster: `docker-registry-default.172.28.33.20.nip.io:80`


First, we need to tag the images appropriately.   
Here, we are specifying for the images to be pushed to the project "myproject".  
Let's also tag the images as "1.0.0" for versioning:  
```bash
$ docker tag webapp-flask:latest docker-registry-default.172.28.33.20.nip.io:80/myproject/webapp-flask:1.0.0
$ docker tag webapp-nginx:latest docker-registry-default.172.28.33.20.nip.io:80/myproject/webapp-nginx:1.0.0
```

You should see a similar list of images to the following, if you run a `docker images`:
```
REPOSITORY                                                              TAG                 IMAGE ID            CREATED              SIZE
docker-registry-default.172.28.33.20.nip.io:80/myproject/webapp-nginx   1.0.0               1a8836b45853        About a minute ago   16.1MB
webapp-nginx                                                            latest              1a8836b45853        About a minute ago   16.1MB
docker-registry-default.172.28.33.20.nip.io:80/myproject/webapp-flask   1.0.0               becdd529e366        About a minute ago   942MB
webapp-flask                                                            latest              becdd529e366        About a minute ago   942MB
nginx                                                                   alpine              dd025cdfe837        9 days ago           16.1MB
python                                                                  3                   a4cc999cf2aa        12 days ago          929MB
openshift/origin-node                                                   v3.11               14d965ab72d5        2 weeks ago          1.17GB
openshift/origin-control-plane                                          v3.11               42f38837c3d6        2 weeks ago          829MB
openshift/origin-haproxy-router                                         v3.11               baa13e07d72c        2 weeks ago          410MB
openshift/origin-deployer                                               v3.11               c4ce187c29d9        2 weeks ago          384MB
openshift/origin-cli                                                    v3.11               3d6b03d3fd9c        2 weeks ago          384MB
openshift/origin-hyperkube                                              v3.11               ba4772ad4b1e        2 weeks ago          509MB
openshift/origin-pod                                                    v3.11               91915f601106        2 weeks ago          262MB
openshift/origin-hypershift                                             v3.11               dcab472bf75a        2 weeks ago          549MB
openshift/origin-docker-registry                                        v3.11               9dffb2abf1dd        3 months ago         310MB
openshift/origin-web-console                                            v3.11               be30b6cce5fa        7 months ago         339MB
openshift/origin-service-serving-cert-signer                            v3.11               47dadf9d43b6        7 months ago         276MB
```

Next, we need to login to the OpenShift integrated repository using our OpenShift credentials.
We can use our current session's token to login with. To retrieve your token:
```bash
$ oc login -u developer | oc whoami -t
```

Now login to the repository with Docker:
```bash
$ docker login -u developer -p $(oc whoami -t) docker-registry-default.172.28.33.20.nip.io:80
```

Finally, we can push the tagged images to the repository:
```bash
$ docker push docker-registry-default.172.28.33.20.nip.io:80/myproject/webapp-flask:1.0.0
$ docker push docker-registry-default.172.28.33.20.nip.io:80/myproject/webapp-nginx:1.0.0
```

Now navigate to the [Image Streams](https://172.28.33.20:8443/console/project/myproject/browse/images) page of your OpenShift project.    
You should see that two image streams have been created that reference 
the images that you just pushed to the integrated repository.

<img src="images/image_streams.png" width="500">


##### Deploy the images

Deploy the images by creating a Deployment Configuration:
```bash

```



##### Create the services

Create the services that will allow the cluster-internal traffic between the two pods.




##### Create the route




### Additional Training Resources
Hopefully, this excercise has given you an introduction into the capabilities that 
OpenShift as a Platform-as-a-Service provides.

Obviously, there are a lot of things that you can do with OpenShift 
that we just don't have the time to cover in this workshop.

For additional resources and training, here are some interactive learning opportunities from the Red Hat team:
- learn.openshift.com
- try.openshift.com



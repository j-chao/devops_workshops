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


### Deploy a Docker image

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


##### Breaking it Down
As you can see, OpenShift makes it relatively easy to quickly deploy applications as containers,
but there's actually a lot that going on here.

1. OpenShift first clones the repo where the source code is, and then 
[builds](https://172.28.33.20:8443/console/project/myproject/browse/builds) an image.
There are a number of 
[build strategies](https://docs.openshift.com/container-platform/3.9/architecture/core_concepts/builds_and_image_streams.html#builds)
that can be used here. In this case, we are using a "Source-to-Image (S2I)" build strategy.
We won't go into the details on the differences between them all, as that is outside the scope of this workshop,
 but just know that the idea is the same as `docker build`.

2. The built image is then pushed to a repository. In this case, OpenShift has 
an integrated repository that is being hosted at `172.30.1.1:5000`. 
(If you don't believe me, ssh into the VM and list the running Docker containers :wink: )

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



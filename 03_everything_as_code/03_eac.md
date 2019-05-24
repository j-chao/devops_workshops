# Everything as Code

<img src="images/jenkins.png" width="150">

### Working with OpenShift & Kubernetes YAML Template Files

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

Recall the steps taken to deploy an image to OpenShift.  

While executing `$ oc new-app` may seem relatively simple, the task for creating, deploying, 
and managing applications become much more tedius as the number of application components scale.

It becomes much more complex of a task when you begin applying health checks, init containers, 
and configuring secrets, configmaps, ingress controllers, TLS-secured routes, and environment variables per different environments.

Fortunately, in the same way that we're able to define our pipelines as code with Jenkinsfiles,
we can define our Kubernetes and OpenShift resources as code in the form of yaml files.

Having all of our containerization strategies, deployment configurations, pipeline configurations, and infrastructure as
code helps us ensure that our infrastructure is immutable and repeatable.  
This helps us reduce risk for when deployments are done to higher environments, and to production.

With our resources defined as yaml files, we can apply the configurations defined using `$ oc apply`:

```bash
$ oc apply -f <resource.yaml or directory containing multiple yaml files>
```


#### DeploymentConfig YAML file
The following yaml file is an example template file for a DeploymentConfig resource object in OpenShift.   
In this case, it represents the deployment configuration for the example flask_app from the first workshop on
containers.

```yaml
kind: DeploymentConfig
apiVersion: v1
metadata:
  labels:
    app: flask-app
  name: flask-app
  namespace: myproject
spec:
  template:
    metadata:
      labels:
        app: flask-app
        deploymentconfig: flask-app
    spec:
      containers:
        - name: flask-app
          image: 172.30.1.1:5000/myproject/flask-app
          ports:
            - containerPort: 5000
              protocol: "TCP"
  replicas: 2
  triggers:
    - type: ConfigChange
    - type: ImageChange
      imageChangeParams:
        automatic: true
        containerNames:
          - flask-app
        from:
          kind: ImageStreamTag
          name: flask-app:1.0.0
  strategy:
    type: Rolling
  paused: false
  revisionHistoryLimit: 2
  minReadySeconds: 0
```


#### Service YAML file

The yaml file below defines the Service resource for the flask_app
```yaml
kind: Service
apiVersion: v1
metadata:
  labels:
    app: flask-app
  name: flask-app
  namespace: myproject
spec:
  ports:
  - name: 5000-tcp
    port: 5000
    protocol: TCP
    targetPort: 5000
  selector:
    app: flask-app
    deploymentconfig: flask-app
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}
```


#### Route YAML file

```yaml
kind: Route
apiVersion: route.openshift.io/v1
metadata:
  labels:
    app: flask-app
  name: flask-app
  namespace: myproject
spec:
  port:
    targetPort: 5000-tcp
  to:
    kind: Service
    name: flask-app
    weight: 100
  wildcardPolicy: None
```


### Creating Your Own YAML files

Try creating and then applying yaml files that define the resources necessary for deploying
the Docker images for the example flask + NGINX multi-container application.

Is it possible to deploy both containers in a single Pod?



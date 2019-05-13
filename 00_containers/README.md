# Docker Container Platform

## Pre-requistes
- Familiarity with using the Terminal.
- git
- VirtualBox preferred; other virtualization techniques are possible but are unsupported.
- Vagrant installed



## Getting Started
### Setting up the environment
Clone the repo and navigate to today's workshop directory:
```bash
$ git clone https://github.optum.com/team-cumulus/devops_workshops.git
$ cd devops_workshops/00_containers
```

Start up the virtual machine.
This will start up an Ubuntu 18.04 VM on your local machine, on a private network with an IP address: `192.168.50.4`.  
Docker will also be provisioned on the VM.
```bash
$ vagrant up
```

Finally, SSH into the virtual machine and ensure that Docker is installed and running:
```bash
$ vagrant ssh
$ docker version
```

You should see the following output
```
Client:
 Version:           18.09.6
 API version:       1.39
 Go version:        go1.10.8
 Git commit:        481bc77
 Built:             Sat May  4 02:35:27 2019
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          18.09.6
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.8
  Git commit:       481bc77
  Built:            Sat May  4 01:59:36 2019
  OS/Arch:          linux/amd64
  Experimental:     false
```

### Resetting the environment
Anytime you want to reset the environment to its original state, run this command:

```bash
$ vagrant halt ; vagrant destroy -f ; vagrant up
```

### Stopping the environment
To stop the virtual machine you can either suspend it:

```bash
$ vagrant suspend
```

or halt it:
```bash
$ vagrant halt
```

---
## Working with Docker 
#### Docker Run
Docker containers are built from Docker images. 
By default, Docker pulls these images from Docker Hub, a Docker registry managed by Docker, 
the company behind the Docker project. 
Anyone can host their Docker images on Docker Hub, so most
applications and Linux distributions you'll need will have images hosted there. 


Run the following command to spin up an Apache server that servers a "Hello World" page listening on port 80, as a Docker
container:
```bash
$ docker run -d -p 80:80 tutum/hello-world
```
- The `-d` flag runs the container in the background and prints the container ID.  
- The `-p` flag publishes the containers port to the host machine. 
In this example, we are publishing port 80 of the Docker machine to port 80 of the host machine, 
so that we can access the application from our host machine.

- `tutum/hello-world` is the image name that we are pulling from here: https://hub.docker.com/r/tutum/hello-world.


You should see output similar to the one below:
```
Unable to find image 'tutum/hello-world:latest' locally
latest: Pulling from tutum/hello-world
658bc4dc7069: Pull complete
a3ed95caeb02: Pull complete
af3cc4b92fa1: Pull complete
d0034177ece9: Pull complete
983d35417974: Pull complete
Digest: sha256:0d57def8055178aafb4c7669cbc25ec17f0acdab97cc587f30150802da8f8d85
Status: Downloaded newer image for tutum/hello-world:latest
e832d972722dfae1a8f687bbd68b62ea735e619e31cd14dd5db6ece29a76a5a4
```
Here, we can see that Docker is pulling the `latest` tagged image from `tutum/hello-world` by default, since we did not
explicitly specify an image tag/version.

Since this is the first time Docker is running this image, it will first download the image to your local machine.
Finally, Docker will spin up a container with the image, and print the container ID associated with the new container.

#### Docker Images

You can view the images that you have currently downloaded on your local machine with the following command:
```bash
docker images
```

You should see output similar to:
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
tutum/hello-world   latest              31e17b0746e4        3 years ago         17.8MB
```

#### Docker Containers
You can view all the currently running containers with:
```bash
docker ps
```

You should see output similar to:
```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
e832d972722d        tutum/hello-world   "/bin/sh -c 'php-fpm…"   6 seconds ago       Up 5 seconds        0.0.0.0:80->80/tcp   gifted_albattani
```


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
$ docker run -d -p 80:80 dockercloud/hello-world
```
- The `-d` flag runs the container in the background and prints the container ID.  
- The `-p` flag publishes the containers port to the host machine. 
In this example, we are publishing port 80 of the Docker machine to port 80 of the host machine, 
so that we can access the application from our host machine.

- `dockercloud/hello-world` is the image name that we are pulling from here: https://hub.docker.com/r/dockercloud/hello-world.


You should see output similar to the one below:
```
Unable to find image 'dockercloud/hello-world:latest' locally
latest: Pulling from dockercloud/hello-world
486a8e636d62: Pull complete
03374a673b41: Pull complete
101d2c41032c: Pull complete
1252e1f36d2b: Pull complete
8385bb1a4377: Pull complete
f29c06131731: Pull complete
Digest: sha256:c6739be46772256abdd1aad960ea8cf6c6a5f841c12e8d9a65cd5ef23bab45fc
Status: Downloaded newer image for dockercloud/hello-world:latest
b0f228753f037ab2dc2df06ae96019f22af45023b6ac1a0d53237b2de9c7d751
```
Here, we can see that Docker is pulling the `latest` tagged image from `dockercloud/hello-world` by default, since we did not
explicitly specify an image tag/version.

Since this is the first time Docker is running this image, it will first download the image to your local machine.
Finally, Docker will spin up a container with the image, and print the container ID associated with the new container.

Now, navigate to `192.168.50.4:80` in your web browser, you should see the "Hello world!" page, with the hostname being the
Container ID of your docker container.


#### Docker Images

You can view the images that you have currently downloaded on your local machine with the following command:
```bash
$ docker images
```

You should see output similar to:
```
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
dockercloud/hello-world   latest              0b898a637c19        23 months ago       30.8MB
```


#### Docker Containers
You can view all the currently running containers with:
```bash
$ docker ps
```

You should see output similar to:
```
CONTAINER ID        IMAGE                     COMMAND                CREATED              STATUS              PORTS                NAMES
b0f228753f03        dockercloud/hello-world   "/bin/sh -c /run.sh"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp   jovial_chandrasekhar
```

To view all containers, both active and inactive, you can run:
```bash
$ docker ps -a
```


#### Interacting with Docker Containers
You can run commands in a running container as well using `docker exec`.

To open an interactive shell, you can pass the `-it` flags like so:
```bash
$ docker exec -it b0f228753f03 /bin/sh
```

`b0f228753f03` is the Container ID in this case.


#### Building your own Docker image with Dockerfiles
A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an
image

Let's take a look at the Dockerfile for the dockercloud/hello-world image:

```Dockerfile
FROM alpine:3.4
LABEL maintainer dockercloud

RUN apk --update add nginx php5-fpm && \
    mkdir -p /run/nginx

ADD www /www
ADD nginx.conf /etc/nginx/
ADD php-fpm.conf /etc/php5/php-fpm.conf
ADD run.sh /run.sh

ENV LISTEN_PORT=80

EXPOSE 80
CMD /run.sh
```

- The `FROM` instruction specifies the Base Image from which you are building.
In this case, we are building from an [Alpine Linux](https://hub.docker.com/_/alpine) base image.
- The `LABEL` instruction allows us to add metadata to the image as a key-value pair.
- The `RUN` instruction allows us to run shell commands. In this example, we are installing nginx and php-fpm, and
  creating any necessary directories.
- The `ADD` instruction copies new files, directories, or remote file URLs from a source, and adds them to the
  filesystem of the image. 
- The `ENV` instruction allows us to set environment variables within the container.
- The `EXPOSE` instruction informs Docker that the container listens on the specified network port(s) at runtime.
- The `CMD` instruction provides defaults for an executing container, usually in the form of an executable.


For more information, you can look at the [Dockerfile reference
docs](https://docs.docker.com/engine/reference/builder/).

#### Bonus: Running Minecraft with Docker
Try running Minecraft in a Docker container now!
```bash
$ docker run -d -p 25565:25565 --name mc itzg/minecraft-server
```

You can watch the logs as the server initializes:
```bash
$ docker logs -f mc
```


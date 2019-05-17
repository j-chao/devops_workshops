# Containers 

## Working with Docker 
To start, SSH into the `docker` VM and ensure that Docker is installed and running:
```bash
$ vagrant ssh docker
$ docker version
```

You should output similar to the following:
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


### Docker Run
Docker containers are built from Docker images. 
By default, Docker pulls these images from Docker Hub, a Docker registry managed by Docker, 
the company behind the Docker project. 
Anyone can host their Docker images on Docker Hub, so most
applications and Linux distributions you'll need will have images hosted there. 


Run the following command to spin up an Apache server that servers a "Hello World" page listening on port 80, as a Docker
container:
```bash
$ docker run -d -p 80:80  --name "hello-world" dockercloud/hello-world
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

Now, navigate to `172.28.33.10:80` in your web browser, you should see the "Hello world!" page, with the hostname being the
Container ID of your docker container.


### Docker Images

You can view the images that you have currently downloaded on your local machine with the following command:
```bash
$ docker images
```

You should see output similar to:
```
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
dockercloud/hello-world   latest              0b898a637c19        23 months ago       30.8MB
```


### Docker Containers
You can view all the currently running containers with:
```bash
$ docker ps
```

You should see output similar to:
```
CONTAINER ID        IMAGE                     COMMAND                CREATED              STATUS              PORTS                NAMES
b0f228753f03        dockercloud/hello-world   "/bin/sh -c /run.sh"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp   hello-world
```

To view all containers, both active and inactive, you can run:
```bash
$ docker ps -a
```



### Interacting with Docker Containers
You can run commands in a running container as well using `docker exec`.

To open an interactive shell, you can pass the `-it` flags like so:
```bash
$ docker exec -it b0f228753f03 /bin/sh
```

`b0f228753f03` is the Container ID in this case.


To get low-level information about Docker objects, you can also use the `docker insepct` command.

`docker rm <container name|ID>` will remove the container.  
`docker rm -f $(docker ps -aq)` will remove all containers.


### Environment Variables & Volumes
You can also pass flags to `docker run` to set environment variables and volumes for containers.

Let's begin by starting a container with an NGINX proxy.
Instead of having the NGINX server serve on the default port 80 from within the container, we can set an environment variable to
serve on port 8000 instead.

Note that while the application may be serving on port 8000 from within the container, we still need to map it to a port
on the host machine. 
In the following example, we are mapping port 8000 of the container to port 8080 of the host
machine.


```bash
$ docker run -d --name "default-nginx" -e NGINX_PORT=8000 -p 8080:8000 nginx:alpine
```

Once the container is running, navigate to `172.28.33.10:8080` in your web browser. 
You should see the default "Welcome to nginx!" landing page.


Let's mount a volume with a different index.html file, and have the NGINX server serve that instead.
To start, create a new `index.html` file:

```bash
$ cat > index.html << EOF
  <html>
      <body>
          <h1>Hello Optum!</h1>
      </body>
  </html>
  EOF
```

Then start up another NGINX container, but this time, pass the `-v` flag to mount the current working directory of your
host machine where the index.html file is located to the `/usr/share/nginx/html` directory of the NGINX container.

Because we're already running the `default-nginx` container on port 8080, let's also change the host port to port 8081:

```bash
$ docker run -d --name "hello-optum" -p 8081:80 -v $(pwd):/usr/share/nginx/html:ro nginx:alpine
```

Now go to `172.28.33.10:8081` in your browser. 
You should see your new index.html file being served instead of the default NGINX landing page now.


What happens if you change the contents of the `index.html` file from your host machine and then reload your web page?



### Building your own Docker image with Dockerfiles
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



### Defining & Running multi-container applications with Docker Compose
Take a look at example Flask application in the flask_app/ directory.

Create a new file called `Dockerfile` and copy 






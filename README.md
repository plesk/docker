# Dockerfiles for Plesk

Dockerfiles for building Plesk images.

# Ready to Use Images

Ready to use images are published at [Docker Hub](https://hub.docker.com/r/plesk/plesk/).

Create a container based on published image:

    docker run -d -it -p 8880:8880 plesk/plesk:preview

Use Docker host IP address and 8880 port for URL to open it in the browser. The following command can be used in the terminal:

    open http://`docker-machine ip`:8880
    
Default login and password: admin / changeme 

# How To Build And Test

Here is an example on how to build the image manually:

    cd 12.5 ; docker build -t plesk/plesk:12.5 .

Create a container to test the image:

    docker run --privileged -d -it -p 8880:8880 plesk/plesk:12.5

# Known Issues

#### Unable to start the container

Symptoms:

    Container dies after start.

Right now it is necessary to run the containers in the priviledged mode using "--privileged" option.

#### Error during building of the image

Symptoms:

    ===> Cumulative APS controller upgrade (final stage) has been started.
    Killed

Starting from Docker 1.10 it is not possible to build the image, sorry. We are working on this problem.

#### Error after initial configuration

Symptoms:

    Unable to configure control panel: reconfig failed: Error while rename file /etc/hosts.tmp:
    Device or resource busy.

Ignore the error and refresh the page in browser (F5).

#### Error after license upload

Symptoms:

    502 Bad Gateway

Ignore the error and refresh the page in browser (F5). 

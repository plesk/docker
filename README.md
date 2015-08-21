# Dockerfiles for Plesk

Dockerfiles for building Plesk images.

# How To Build And Test

Here is an example on how to build the image manually:

    cd 12.0 ; docker build -t plesk:12.0 .

Create a container to test the image:

    docker run -d -P -it plesk:12.0

Open the URL with port which was mapped to 8880 port inside container.

Default login and password: admin / changeme 

# Known Issues

#### Error after initial configuration

    Unable to configure control panel: reconfig failed: Error while rename file /etc/hosts.tmp:
    Device or resource busy.

Ignore the error and refresh the page in browser (F5).

#### Error after license upload

    502 Bad Gateway

Ignore the error and refresh the page in browser (F5). 

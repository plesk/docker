# Dockerfiles for Plesk

Dockerfiles for building Plesk images.

# How To Build And Test

Here is an example on how to build the image manually:

    cd 12.5 ; docker build -t plesk/plesk:12.5 .

Create a container to test the image:

    docker run -d -it -p 8880:8880 plesk/plesk:12.5

Open IP:8880 URL using browser.

Default login and password: admin / changeme 

# Known Issues

#### Error during building of the image on Ubuntu

Symptoms:

    ===> Cumulative APS controller upgrade (final stage) has been started.
    Killed

Or:

    DEBUGGER DETECTED... Bye!
    Killed

Disable AppArmor and try to build the image again.

#### Error after initial configuration

    Unable to configure control panel: reconfig failed: Error while rename file /etc/hosts.tmp:
    Device or resource busy.

Ignore the error and refresh the page in browser (F5).

#### Error after license upload

    502 Bad Gateway

Ignore the error and refresh the page in browser (F5). 

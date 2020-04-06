# Dockerfiles for Plesk

Dockerfiles for building Plesk images.

# Ready to Use Images

Ready to use images are published at [Docker Hub](https://hub.docker.com/r/plesk/plesk/).

Create a container based on published image for evaluation purposes:

    docker run -d -p 8880:8880 plesk/plesk

Use Docker host IP address and 8880 port for URL to open it in the browser. The following command can be used in the terminal:

    open http://`docker-machine ip`:8880
    
Default login and password: admin / changeme (for 17.8), admin / changeme1Q** (for 18.0/latest)

Create a container with typical port mapping:

    docker run -d -p 80:80 -p 443:443 -p 8880:8880 -p 8443:8443 -p 8447:8447 plesk/plesk

Automatic port mapping can be used to publish all exposed ports to random ports with the high numbers:

    docker run -d -P plesk/plesk

# How To Build And Test

Here is an example on how to build the image manually:

    cd latest ; docker build --no-cache --build-arg "LICENSE=A00A00-38PZ06-448D38-Y2BA16-D4GD66" -t plesk/plesk .

Create a container to test the image:

    docker run -d -p 8880:8880 plesk/plesk

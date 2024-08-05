# Dockerfiles for Plesk

[![Test Status](https://github.com/plesk/docker/actions/workflows/test.yml/badge.svg)](https://github.com/plesk/docker/actions/workflows/test.yml)

Dockerfiles for building Plesk images.

# Ready to Use Images

Ready to use images are published at [Docker Hub](https://hub.docker.com/r/plesk/plesk/).

Create a container based on published image for evaluation purposes:

    docker run -d \
        --tmpfs /tmp \
        --tmpfs /run \
        --tmpfs /run/lock \
        -v /sys/fs/cgroup:/sys/fs/cgroup \
        --cgroupns=host \
        --cap-add SYS_ADMIN \
        --security-opt apparmor=unconfined \
        -p 8880:8880 \
        plesk/plesk

Use Docker host IP address and 8880 port for URL to open it in the browser. The following command can be used in the terminal:

    open http://localhost:8880

Default login and password: `admin` / `changeme1Q**`

Create a container with typical port mapping:

    docker run -d \
        --tmpfs /tmp \
        --tmpfs /run \
        --tmpfs /run/lock \
        -v /sys/fs/cgroup:/sys/fs/cgroup \
        --cgroupns=host \
        --cap-add SYS_ADMIN \
        --security-opt apparmor=unconfined \
        -p 80:80 \
        -p 443:443 \
        -p 8880:8880 \
        -p 8443:8443 \
        -p 8447:8447 \
        plesk/plesk

# How To Build And Test

Here is an example on how to build the image manually:

    cd latest ; docker build --no-cache --build-arg "LICENSE=A00Y00-1KWH10-REFG92-T9JF97-TBXC06" -t plesk/plesk .

Create a container to test the image:

    docker run -d \
        --tmpfs /tmp \
        --tmpfs /run \
        --tmpfs /run/lock \
        -v /sys/fs/cgroup:/sys/fs/cgroup \
        --cgroupns=host \
        --cap-add SYS_ADMIN \
        --security-opt apparmor=unconfined \
        -p 8880:8880 \
        plesk/plesk

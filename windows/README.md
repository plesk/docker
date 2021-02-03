Plesk for Windows Docker Image
======================================================

* [Introduction](#introduction)
* [Mandatory requirements](#mandatory-requirements)
* [How To Use Ready Image](#how-to-use-ready-image)
* [How To Build Docker Image](#how-to-build-docker-image)
* [How To Run Docker Container](#how-to-run-docker-container)
* [How To Use Plesk Image On AWS EC2](#how-to-use-plesk-image-on-aws-ec2)

# Introduction

We have been using Linux docker images for a long time. Docker image for Windows has appeared only now, so Plesk for Windows can be run in containers.

In the long term, this should give more opportunities to improve the process of testing windows-specific functionality of Plesk.

# Mandatory requirements

* Building an image for Windows must be performed on a server with installed Windows Server 2019.
* The OS version of the host system and the image version of Windows Server 2019 must be identical to run a ready image or build a new local image.
* Otherwise, the build or the run will fail (in particular, there are problems with Microsoft Visual C ++ Redistributable installing.).

In order to fix it, you need to make sure that the versions match:

    cmd.exe /S /C ver

    Microsoft Windows [Version 10.0.17763.1697]

Link to check OS version, in the image: [https://hub.docker.com/\_/microsoft-windows-servercore](https://hub.docker.com/_/microsoft-windows-servercore)

| Tags     | Architecture | Dockerfile    | OsVersion       | CreatedTime         | LastUpdatedTime     |
| ---------|:------------:|:-------------:|:---------------:|:-------------------:|:-------------------:|
| ltsc2019 | multiarch    | No Dockerfile | 10.0.17763.1697 | 10/03/2018 20:30:05 | 01/12/2021 18:03:09 |

If the operating system version is outdated, you need to install all the latest updates.

# How To Use Ready Image

To create a container based on published image, run the command:

    docker run -d -p 8880:8880 --name plesk plesk/plesk-windows

Use Docker host IP address and 8880 port for URL to open it in the browser. The following command can be used in the terminal:

    Start-Process "http://localhost:8880"

# How To Build Docker Image

You can start the process of building docker image with the following command:

    docker build --no-cache --build-arg "LICENSE=A00A00-38PZ06-448D38-Y2BA16-D4GD66" -t plesk/plesk-windows .

# How To Run Docker Container

The container is launched with the following command:

    docker run -d -p 443:443 -p 8880:8880 -p 8443:8443 -p 8447:8447 --rm --name plesk plesk/plesk-windows

# How To Use Plesk Image On AWS EC2

* Choose an Amazon Machine Image for EC2 instance with name "Microsoft Windows Server 2019 Base with Containers".
* Choose an Instance Type t2.large with 8GB RAM and 50-60GB storage size.

After starting the instance, run the command:

    docker run -d -p 8880:8880 --name plesk plesk/plesk-windows

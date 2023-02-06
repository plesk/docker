# Plesk for Windows Docker Image

* [Introduction](#introduction)
* [Requirements](#requirements)
* [How To Use Plesk Image](#how-to-use-plesk-image)
* [How To Build Docker Image](#how-to-build-docker-image)
* [How To Use Plesk Image On AWS EC2](#how-to-use-plesk-image-on-aws-ec2)

# Introduction

The directory contains a Dockerfile, which helps you to build an image with Plesk for Windows product.

Plesk for Windows as a Docker container is an experimental project. Please use it only for evaluation and testing purposes at your own risk.

# Requirements

* Building an image for Windows must be performed on a server with Windows Server 2019 installed.
* The OS version of the host system and the image version of Windows Server 2019 must be identical to run a container or build a new local image.
* Otherwise, the build procedure or the launch of the container may fail (in particular, there can be a problem with Microsoft Visual C++ Redistributable installation).

In order to fix it, you need to make sure that the versions match:

    cmd.exe /S /C ver

    Microsoft Windows [Version 10.0.17763.1697]

To check the version of the base OS image, use the following link: [https://hub.docker.com/\_/microsoft-windows-servercore](https://hub.docker.com/_/microsoft-windows-servercore)

| Tags     | Architecture | Dockerfile    | OsVersion       | CreatedTime         | LastUpdatedTime     |
| ---------|:------------:|:-------------:|:---------------:|:-------------------:|:-------------------:|
| ltsc2019 | multiarch    | No Dockerfile | 10.0.17763.1697 | 10/03/2018 20:30:05 | 01/12/2021 18:03:09 |

If the OS version is outdated, you need to install all the latest updates.

# How To Use Plesk Image

To create a container based on published image, run the command:

    docker run -d -p 8880:8880 --name plesk plesk/plesk-windows

Use Docker host IP address and 8880 port for URL to open it in the browser. The following command can be used in the terminal:

    Start-Process "http://localhost:8880"

# How To Build Docker Image

You can start the process of building Docker image with the following command:

    docker build --no-cache --build-arg "LICENSE=A00A00-Y8BA10-JB1123-3RAS71-EJ3E92" -t plesk/plesk-windows .

# How To Use Plesk Image On AWS EC2

* Choose an Amazon Machine Image for EC2 instance with name "Microsoft Windows Server 2019 Base with Containers".
* Choose an Instance Type t2.large with 8GB RAM and 50-60GB storage size.

After starting the instance, run the command:

    docker run -d -p 8880:8880 --name plesk plesk/plesk-windows

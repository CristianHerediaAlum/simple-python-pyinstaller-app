# Instalación imagen Jenkins
Obtenemos las imágenes correspondientes
- `docker pull jenkins/jenkins`
- `docker pull docker:dind`

Creamos una red de tipo bridge
- `docker network create jenkins`

Con esto tendremos Jenkins y docker in docker disponible para utilizarse.

Creamos una imagen de docker dentro de docker:
- `docker run --privileged -d --name dind-test docker:dind` (Creamos dind-test)
- `docker exec -it dind-test /bin/sh` (La ejecutamos)
- `docker pull ubuntu` (Descargamos la imagen de ubuntu) 
- `docker images` (Comprobamos las imágenes que hay)
- ` mkdir test && cd test` (Creamos una carpeta test y nos movemos a ella)
- `vi Dockerfile` (Modificamos el archivo Dockerfile), escribiendo:

        FROM ubuntu:18.04
        RUN apt-get update && \
        apt-get -qy full-upgrade && \
        apt-get install -qy curl && \
        apt-get install -qy curl && \
        curl -sSL https://get.docker.com/ | sh 

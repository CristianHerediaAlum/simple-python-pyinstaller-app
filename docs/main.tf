terraform {
required_providers {
    docker = {
        source = "kreuzwerker/docker"
        version = "~> 3.0.1"
    }
}
}

provider "docker" {host = "npipe:////.//pipe//docker_engine"}

resource "docker_network" "jenkins" {
  name="jenkins"
}

# Volumen para certificados
resource "docker_volume" "certs" {
  name = "jenkins-docker-certs"
}

# Volumen para Jenkins home
resource "docker_volume" "jenkins_home" {
  name = "jenkins-data"
}

# Contenedor Docker-in-Docker
resource "docker_container" "dind" {
  name  = "dind"
  image = "docker:dind"
  privileged = true
  networks_advanced {
    name = docker_network.jenkins.name
    aliases = ["docker"]
  }
  volumes {
    volume_name = docker_volume.certs.name
    container_path = "/certs/client"
  }
  volumes {
    volume_name = docker_volume.jenkins_home.name
    container_path = "/var/jenkins_home"
  }
  env = [
    "DOCKER_TLS_CERTDIR=/certs"
  ]
  ports {
    internal = 2375
    external = 2375
  }
}

resource "docker_container" "jenkins" {
  image = "myjenkins-blueocean"
  name  = "jenkins"
  networks_advanced {
    name = docker_network.jenkins.name
  }
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
  ports {
    internal = 8080
    external = 8080
  }
  ports {
    internal = 50000
    external = 50000
  }
}
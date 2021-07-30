locals {
  app = "qbittorrent"
}


terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.14.0"
    }
  }
}

provider "docker" {
  #host = "tcp://docker:2345/"
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "config" {
  name = "pknw1/config:latest"
}

resource "docker_image" "nginx" {
  name = "linuxserver/qbittorrent"
}

resource "docker_volume" "config" {
  name = "config"
}

resource "docker_container" "config" {
  name    = "config"
  image   = "${docker_image.config.latest}"
  restart = "always"
#  mounts  {
#      target = "/config"
#      type = "bind"
#      source = "/tmp/config-${local.app}"
#  }
  mounts {
      target = "/config"
      type   = "volume"
      source = "config"
  }

  mounts {
      target = "/root/.ssh"
      type = "bind"
      source = "/root/.ssh"
  }
  env = ["PUID=666", "PGID=666"]

}

resource "docker_container" "nginx-server" {
  name = "nginx-server"
  depends_on = [ docker_container.config ]
  image = "linuxserver/qbittorrent:latest"
  ports {
    internal = 8080
  }
  env = ["VIRTUAL_HOST=test.pknw1.co.uk", "VIRTUAL_PORT=3000", "VIRTUAL_PROTO=http", "TZ=Europe/London", "PUID=666", "PGID=666"]
  networks_advanced {
    name = "proxy"
  }

#  mounts { 
#    target = "/config"
#    type   = "bind"
#    source = "/tmp/config-${local.app}"
#  }
 mounts {
      target = "/config"
      type   = "volume"
      source = "config"
  }
}

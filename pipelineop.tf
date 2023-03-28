terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    postgresql = {
      source = "cyrilgdn/postgresql"
    }
  }
}

resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}

resource "docker_container" "apache" {
  name  = "my-apache-container-${count.index}"
  count = local.containers
  image = docker_image.ubuntu.name
  ports {
    internal = 22
    external = 2222 + count.index
  }
  ports {
    internal = 80
    external = 9000 + count.index
  }
  volumes {
    host_path      = "C:/Users/Patrick/OneDrive - Office 365 Fontys/Semester 3/Automation/Aut1/index.html"
    container_path = "/var/www/html/index.html"
    read_only      = false
  }

  command = ["/bin/bash", "-c", "apt-get update && apt-get install -y apache2 openssh-server && service ssh start && mkdir -p /root/.ssh && chmod 700 /root/.ssh && touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys && echo \"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCLg39A8sS3Z5TWYOUOoXIOFrmldR+CYgFHyWh32WZffsTtckfc1cXHI0FqOggLy3hKJSm29+80Vo3EDG6mazYf+nQYrf5Rhsef5i+7HAeb9gB46sFbgOd1VSMNZ5sUCjlQl1qGm5LUggD36z83XxMFqGaukOnyELXv4xaQjOb0UIrApvfZTDsTmwn0fDkaloInUOpIvybQ8qc9JJlot9BOeWYlWyv8TJcedO+bMCuqFjxBYWI5L+mGmTaLB1PELgdkIYYIkP/9MoBYmXBDjdDGIIwon6qNCBzb/F+QvDb2kKdrYVmH0ddSb1SI2vMRCh8MXNRPKn4Vpw9pMKhZ0bvR rsa-key-20230327\" >> /root/.ssh/authorized_keys && /usr/sbin/apache2ctl -D FOREGROUND && /usr/sbin/sshd -D"]
  attach       = true
  tty          = true
  restart      = "always"
  privileged   = true
  working_dir  = "/"
  network_mode = "bridge"
}

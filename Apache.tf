terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "apache" {
  name         = "httpd:latest"
}



resource "docker_container" "apache" {
  name         = "apachecontainer-${count.index}"
  count        = local.apache
  image        = docker_image.apache.name
  ports {
    internal = 80
    external = 8080 + count.index
  }
  
  volumes {
    host_path      = "C:/Users/Patrick/OneDrive - Office 365 Fontys/Semester 3/Automation/Aut1/index.html"
    container_path = "/usr/local/apache2/htdocs/index.html"
    read_only      = false
  }
}



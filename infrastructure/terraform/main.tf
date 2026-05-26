terraform {
  required_providers {
    k3d = {
      source  = "nikhilsbhat/k3d"
      version = "0.0.2"
    }
  }
}

provider "k3d" {}

resource "k3d_cluster" "fintech_cluster" {
  name    = "fintech-cluster"
  image   = "rancher/k3s:v1.31.5-k3s1"

  # Описываем ноды по одной
  nodes {
    role = "server"
  }
  nodes {
    role = "agent"
  }
  nodes {
    role = "agent"
  }

  # Исправленный блок портов
  ports {
    host           = "80"
    container_port = 80
    node_filters   = ["loadbalancer"]
  }

  # Настройки API
  kube_api {
    host_ip   = "0.0.0.0"
    host_port = 6443
  }
}

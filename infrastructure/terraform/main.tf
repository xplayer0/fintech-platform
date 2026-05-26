terraform {
  required_providers {
    k3d = {
      source  = "pvotal-tech/k3d"
      version = "0.0.7"
    }
  }
}

provider "k3d" {}

resource "k3d_cluster" "fintech_cluster" {
  name    = "fintech-cluster"
  servers = 1
  agents  = 2 # Имитируем многонодовый кластер (Worker nodes)

  kube_api {
    host_ip   = "0.0.0.0"
    host_port = 6443
  }

  image   = "rancher/k3s:v1.27.4-k3s1"

  # Пробрасываем порты для нашего будущего API-Gateway (80 и 443)
  port {
    host_port      = 80
    container_port = 80
    node_filters   = ["loadbalancer"]
  }

  k3d {
    disable_loadbalancer = false
    disable_image_volume  = false
  }
}

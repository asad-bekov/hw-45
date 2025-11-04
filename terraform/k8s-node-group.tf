resource "yandex_kubernetes_node_group" "netology-node-group" {
  cluster_id = yandex_kubernetes_cluster.netology-k8s.id
  name       = "netology-node-group"
  version    = "1.31"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.public_subnet_a.id]
    }

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
    
    maintenance_window {
      day        = "monday"
      start_time = "23:00"
      duration   = "3h"
    }
  }

  depends_on = [
    yandex_kubernetes_cluster.netology-k8s
  ]
}

data "yandex_iam_service_account" "k8s-sa" {
  name = "terraform-sa"
}

resource "yandex_kubernetes_cluster" "netology-k8s" {
  name        = "netology-k8s"
  description = "Netology Kubernetes Cluster"

  network_id = data.yandex_vpc_network.existing_network.id

  cluster_ipv4_range = "10.1.0.0/16"
  service_ipv4_range = "10.2.0.0/16"

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = "ru-central1-a"
        subnet_id = yandex_vpc_subnet.public_subnet_a.id
      }
      location {
        zone      = "ru-central1-b"
        subnet_id = yandex_vpc_subnet.public_subnet_b.id
      }
      location {
        zone      = "ru-central1-d"
        subnet_id = yandex_vpc_subnet.public_subnet_d.id
      }
    }

    # Убираем явное указание версии или используем актуальную
    version   = "1.31"  # Или просто удали эту строку
    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "03:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = data.yandex_iam_service_account.k8s-sa.id
  node_service_account_id = data.yandex_iam_service_account.k8s-sa.id

  kms_provider {
    key_id = data.yandex_kms_symmetric_key.kms-key.id
  }

  release_channel = "REGULAR"
  network_policy_provider = "CALICO"
  
  depends_on = [
    yandex_vpc_subnet.public_subnet_a,
    yandex_vpc_subnet.public_subnet_b,
    yandex_vpc_subnet.public_subnet_d
  ]
}

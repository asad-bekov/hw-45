resource "yandex_mdb_mysql_cluster" "netology-mysql" {
  name                = "netology-mysql"
  environment         = "PRESTABLE"
  network_id          = data.yandex_vpc_network.existing_network.id
  version             = "8.0"
  deletion_protection = false

  resources {
    resource_preset_id = "b2.medium"
    disk_type_id       = "network-hdd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.private_subnet_a.id
  }

  host {
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.private_subnet_b.id
  }

  host {
    zone      = "ru-central1-d"
    subnet_id = yandex_vpc_subnet.private_subnet_d.id
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.netology-mysql.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "netology_user" {
  cluster_id = yandex_mdb_mysql_cluster.netology-mysql.id
  name       = "netology_user"
  password   = var.mysql_password
  
  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
}

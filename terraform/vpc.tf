resource "yandex_vpc_subnet" "private_subnet_a" {
  name           = "private-subnet-a"
  zone           = "ru-central1-a"
  network_id     = data.yandex_vpc_network.existing_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "private_subnet_b" {
  name           = "private-subnet-b"
  zone           = "ru-central1-b"
  network_id     = data.yandex_vpc_network.existing_network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "private_subnet_d" {
  name           = "private-subnet-d"
  zone           = "ru-central1-d"
  network_id     = data.yandex_vpc_network.existing_network.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

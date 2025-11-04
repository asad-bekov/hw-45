data "yandex_vpc_network" "existing_network" {
  name = "lamp-network"
}

data "yandex_kms_symmetric_key" "kms-key" {
  name = "netology-bucket-key" 
}

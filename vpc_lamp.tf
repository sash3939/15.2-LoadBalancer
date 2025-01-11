#---- Создани подсети нужна одна на все ВМ --------------

resource "yandex_vpc_network" "cloud-net" {
  name = "cloud-net"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.cloud-net.id}"
}

#Провайдер
terraform {
  required_version = "= 1.6.5"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.73"
    }
  }
}
provider "yandex" {
  token     = "y0_..._H1UUw"
  cloud_id  = "b1..."
  folder_id = "b1g..."
  zone      = "ru-central1-a"
}

#Security_Group
#Nginx
resource "yandex_vpc_security_group" "nginx" {
  name        = "priv-nginx"
  description = "Private Group Nginx"
  network_id  = "enp6vemvs9o2f30iic6i"

  ingress {
    protocol       = "ANY"
    description    = "Rule description 1"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Rule description 2"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#Elastic
resource "yandex_vpc_security_group" "elastic" {
  name        = "priv-elastic"
  description = "Private Group Elasticsearch"
  network_id  = "enp6vemvs9o2f30iic6i"

  ingress {
    protocol       = "ANY"
    description    = "Rule description 1"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Rule description 2"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#Zabbix-server
resource "yandex_vpc_security_group" "zabbix" {
  name        = "pub-zabbix"
  description = "Public Group Zabbix"
  network_id  = "enp6vemvs9o2f30iic6i"

  ingress {
    protocol       = "ANY"
    description    = "Connect to Zabbix-server"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Out connect"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#Kibana
resource "yandex_vpc_security_group" "kibana" {
  name        = "pub-kibana"
  description = "Public Group Kibana"
  network_id  = "enp6vemvs9o2f30iic6i"

  ingress {
    protocol       = "ANY"
    description    = "Connect to Kibana"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Out connect"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#L7-balancer
resource "yandex_vpc_security_group" "balance" {
  name        = "pub-balance"
  description = "Public Group L7-balance"
  network_id  = "enp6vemvs9o2f30iic6i"

  ingress {
    protocol          = "TCP"
    description       = "Health check"
    predefined_target = "loadbalancer_healthchecks"
  }

  ingress {
    protocol       = "ANY"
    description    = "Connect to Balance"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  egress {
    protocol       = "ANY"
    description    = "Out connect"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
#VM Nginx - 1
resource "yandex_compute_instance" "nginx-1" {
  name = "nginx-1"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
    }
  }

  network_interface {
    subnet_id          = "e9bcclnvcrp5ho7m2bcm"
    nat                = true
    security_group_ids = [yandex_vpc_security_group.nginx.id]
  }

  metadata = {
    user-data = "${file("/home/user/terraform/yandex/meta.yml")}"
  }
}

#VM Nginx - 2
resource "yandex_compute_instance" "nginx-2" {
  name = "nginx-2"
  zone = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
    }
  }

  network_interface {
    subnet_id          = "e2l0jajhcjefhm4e0rlt"
    nat                = true
    security_group_ids = [yandex_vpc_security_group.nginx.id]
  }

  metadata = {
    user-data = "${file("/home/user/terraform/yandex/meta.yml")}"
  }
}

#VM Zabbix
resource "yandex_compute_instance" "zabbix" {
  name     = "zabix"
  hostname = "zabbix-server"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
    }
  }
  network_interface {
    subnet_id          = "e9bcclnvcrp5ho7m2bcm"
    nat                = true
    security_group_ids = [yandex_vpc_security_group.zabbix.id]
  }
  metadata = {
    user-data = "${file("/home/user/terraform/yandex/meta.yml")}"
  }
}

#VM Elastic
resource "yandex_compute_instance" "elastic" {
  name     = "elastic"
  hostname = "elastic"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
    }
  }
  network_interface {
    subnet_id          = "e9bcclnvcrp5ho7m2bcm"
    nat                = true
    security_group_ids = [yandex_vpc_security_group.elastic.id]
  }
  metadata = {
    user-data = "${file("/home/user/terraform/yandex/meta.yml")}"
  }
}

#VM Kibana
resource "yandex_compute_instance" "kibana" {
  name     = "kibana"
  hostname = "kibana"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    memory = 6
  }

  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
    }
  }
  network_interface {
    subnet_id          = "e9bcclnvcrp5ho7m2bcm"
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kibana.id]
  }
  metadata = {
    user-data = "${file("/home/user/terraform/yandex/meta.yml")}"
  }
}

#VM Bastion
resource "yandex_compute_instance" "bastion" {
  name = "bastion"
  hostname = "bastion"
  zone = "ru-central1-a"

  resources{
    cores = 2
    core_fraction = 20
    memory = 2
  }

  boot_disk{
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
      size = 10
    }
  }
  network_interface {
    subnet_id = "e9bcclnvcrp5ho7m2bcm"
    nat = true
        security_group_ids = [yandex_vpc_security_group.bastion.id]
  }
  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}
#---
resource "yandex_vpc_security_group" "bastion" {
  name        = "pub-bastion"
  description = "Public Group bastion"
  network_id  = "enp6vemvs9o2f30iic6i"

  ingress {
    protocol       = "ANY"
    description    = "Connect to Bastion"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Out connect"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#Target Group
resource "yandex_alb_target_group" "target-group" {
  name = "target-group"

  target {
    subnet_id  = "e9bcclnvcrp5ho7m2bcm"
    ip_address = yandex_compute_instance.nginx-1.network_interface.0.ip_address
  }

  target {
    subnet_id  = "e2l0jajhcjefhm4e0rlt"
    ip_address = yandex_compute_instance.nginx-2.network_interface.0.ip_address
  }
}

#Backend
resource "yandex_alb_backend_group" "backend-group" {
  name = "backend-group"

  http_backend {
    name             = "backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.target-group.id]
    load_balancing_config {
      panic_threshold = 90
    }
    healthcheck {
      timeout             = "10s"
      interval            = "2s"
      healthy_threshold   = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/"
      }
    }
  }
}

#HTTP
resource "yandex_alb_http_router" "http-router" {
  name = "http-router"
  labels = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name           = "my-virtual-host"
  http_router_id = yandex_alb_http_router.http-router.id
  route {
    name = "router"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
        timeout          = "60s"
      }
    }
  }
}
#L7 Balancer
resource "yandex_alb_load_balancer" "my-balancer" {
  name               = "my-balancer"
  network_id         = "enp6vemvs9o2f30iic6i"
  security_group_ids = [yandex_vpc_security_group.balance.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = "e9bcclnvcrp5ho7m2bcm"
    }
  }

  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id
      }
    }
  }
}
#
#resource "yandex_vpc_network" "network-1" {
#  name = "network1"
#}

#resource "yandex_vpc_subnet" "subnet-1" {
#  name           = "subnet1"
#  zone           = "ru-central1-a"
#  network_id     = yandex_vpc_network.network-1.id
#  v4_cidr_blocks = ["192.168.10.0/24"]
#}

#output "internal_ip_address_vm_1" {
#  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
#}
#
#output "internal_ip_address_vm_2" {
#  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
#}
#
#output "external_ip_address_vm_1" {
#  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
#}
#
#output "external_ip_address_vm_2" {
#  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
#}

data "hcloud_location" "location1" {
  name = var.location
}

resource "hcloud_network" "main" {
  name   = "main-network"
  labels = var.labels

  ip_range = "10.0.0.0/9"
}

resource "hcloud_network_subnet" "eu1" {
  network_id = hcloud_network.main.id

  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.70.0.0/16"
}

resource "hcloud_server_network" "kube_master_main" {
  count = var.masters_count

  server_id  = hcloud_server.kube_master[count.index].id
  network_id = hcloud_network.main.id

  lifecycle {
    ignore_changes = [alias_ips]
  }
}

resource "hcloud_server_network" "kube_worker_main" {
  count = var.workers_count

  server_id  = hcloud_server.kube_worker[count.index].id
  network_id = hcloud_network.main.id
}

resource "hcloud_floating_ip" "apiserver_fip" {
  count = var.master_apiserver_loadbalancer == "fip" ? 1 : 0

  name = "kube-apiserver"
  labels = var.labels

  type = "ipv4"
  home_location = data.hcloud_location.location1.name
}

resource "hcloud_floating_ip" "kube_fip" {
  count = var.fips_count

  name   = "kube-fip${count.index}"
  labels = var.labels

  type          = "ipv4"
  home_location = data.hcloud_location.location1.name
}

resource "hcloud_load_balancer" "master" {
  count = var.master_apiserver_loadbalancer == "hetznerlb" ? 1 : 0

  load_balancer_type = "lb11"
  network_zone = hcloud_network_subnet.eu1.network_zone
  name = "kube-master"
  labels = var.labels
}

resource "hcloud_load_balancer_network" "master" {
  count = var.master_apiserver_loadbalancer == "hetznerlb" ? 1 : 0

  load_balancer_id = hcloud_load_balancer.master[0].id
  subnet_id = hcloud_network_subnet.eu1.id
}

resource "hcloud_load_balancer_target" "master" {
  count = var.master_apiserver_loadbalancer == "hetznerlb" ? var.masters_count : 0

  load_balancer_id = hcloud_load_balancer.master[0].id
  type = "server"
  server_id = hcloud_server_network.kube_master_main[count.index].server_id
  use_private_ip = true
}

resource "hcloud_load_balancer_service" "apiserver" {
  count = var.master_apiserver_loadbalancer == "hetznerlb" ? 1 : 0

  load_balancer_id = hcloud_load_balancer.master[0].id
  protocol = "tcp"
  listen_port = 443
  destination_port = 6443

  health_check {
    interval = 10
    port = 6443
    protocol = "tcp"
    timeout = 10
  }
}

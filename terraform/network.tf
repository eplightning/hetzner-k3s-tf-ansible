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
}

resource "hcloud_server_network" "kube_worker_main" {
  count = var.workers_count

  server_id  = hcloud_server.kube_worker[count.index].id
  network_id = hcloud_network.main.id
}

resource "hcloud_floating_ip" "apiserver_fip" {
  count = var.apiserver_loadbalancer_type == "fip" ? 1 : 0

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

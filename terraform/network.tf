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
  server_id  = hcloud_server.kube_master.id
  network_id = hcloud_network.main.id
}

resource "hcloud_server_network" "kube_worker_main" {
  count = var.workers_count

  server_id  = hcloud_server.kube_worker[count.index].id
  network_id = hcloud_network.main.id
}

resource "hcloud_rdns" "kube_master0" {
  count = var.master_external_hostname != "" ? 1 : 0

  server_id = hcloud_server.kube_master.id

  ip_address = hcloud_server.kube_master.ipv4_address
  dns_ptr    = var.master_external_hostname
}

resource "hcloud_floating_ip" "kube_fip" {
  count = var.fips_count

  name   = "kube-fip${count.index}"
  labels = var.labels

  type          = "ipv4"
  home_location = data.hcloud_location.location1.name
}

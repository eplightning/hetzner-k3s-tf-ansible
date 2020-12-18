output "master_ipv4_addresses" {
  value = hcloud_server.kube_master[*].ipv4_address
}

output "worker_ipv4_addresses" {
  value = hcloud_server.kube_worker[*].ipv4_address
}

output "apiserver_ipv4_address" {
  value = local.apiserver_ip_map[var.master_apiserver_loadbalancer]
}

output "ssh_port" {
  value = var.ssh_port
}

output "master_ipv4_addresses" {
  value = hcloud_server.kube_master[*].ipv4_address
}

output "worker_ipv4_addresses" {
  value = hcloud_server.kube_worker[*].ipv4_address
}

output "ssh_port" {
  value = var.ssh_port
}

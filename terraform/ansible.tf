resource "local_file" "hosts" {
  filename = abspath("${path.module}/../ansible/inventory/hosts.ini")

  content = templatefile("${path.module}/templates/hosts.ini", {
    private_network : hcloud_network.main,
    hcloud_token : var.hcloud_token_kubernetes,
    master_external_hostname : var.master_external_hostname,
    enabled_addons : var.enabled_addons,

    ssh_port : var.ssh_port,
    open_tcp_ports : setunion(var.additional_open_tcp_ports, [var.ssh_port]),
    open_udp_ports : var.additional_open_udp_ports,

    masters : [{ server : hcloud_server.kube_master, network : hcloud_server_network.kube_master_main }],
    workers : [for i in range(var.workers_count) : { server : hcloud_server.kube_worker[i], network : hcloud_server_network.kube_worker_main[i] }],

    floating_ips : hcloud_floating_ip.kube_fip
  })
}

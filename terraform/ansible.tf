resource "local_file" "hosts" {
  filename = abspath("${path.module}/../ansible/inventory/hosts.ini")

  content = templatefile("${path.module}/templates/hosts.ini", {
    private_network : hcloud_network.main,
    hcloud_token : var.hcloud_token_kubernetes,

    enabled_addons : var.enabled_addons,
    cni_type : var.cni_type,
    loadbalancer_type : var.loadbalancer_type,

    apiserver_datastore : var.masters_count > 1 ? "etcd" : var.apiserver_datastore,
    apiserver_external_hostname : var.apiserver_external_hostname,
    apiserver_loadbalancer_type : var.apiserver_loadbalancer_type,
    apiserver_ip : var.apiserver_loadbalancer_type == "fip" ? hcloud_floating_ip.apiserver_fip[0].ip_address : hcloud_server_network.kube_worker_main[0].ip,
    apiserver_fip_id: var.apiserver_loadbalancer_type == "fip" ? hcloud_floating_ip.apiserver_fip[0].id : 0,

    ssh_port : var.ssh_port,
    open_tcp_ports : setunion(var.additional_open_tcp_ports, [
      var.ssh_port
    ]),
    open_udp_ports : var.additional_open_udp_ports,

    masters : [for i in range(var.masters_count) : {
      server : hcloud_server.kube_master[i],
      network : hcloud_server_network.kube_master_main[i]
    }],
    workers : [for i in range(var.workers_count) : {
      server : hcloud_server.kube_worker[i],
      network : hcloud_server_network.kube_worker_main[i]
    }],

    floating_ips : hcloud_floating_ip.kube_fip
  })
}

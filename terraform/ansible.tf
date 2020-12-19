locals {
  privatenetwork_apiserver_ip = "10.70.255.1"

  apiserver_ip_map = {
    hetznerlb: var.master_apiserver_loadbalancer != "hetznerlb" ? "" : hcloud_load_balancer.master[0].ipv4,
    fip: var.master_apiserver_loadbalancer != "fip" ? "" : hcloud_floating_ip.apiserver_fip[0].ip_address,
    privatenetwork: hcloud_server.kube_master[0].ipv4_address,
    none: hcloud_server.kube_master[0].ipv4_address
  }

  apiserver_internal_ip_map = {
    hetznerlb: var.master_apiserver_loadbalancer != "hetznerlb" ? "" : hcloud_load_balancer.master[0].ipv4,
    fip: var.master_apiserver_loadbalancer != "fip" ? "" : hcloud_floating_ip.apiserver_fip[0].ip_address,
    privatenetwork: local.privatenetwork_apiserver_ip,
    none: hcloud_server.kube_master[0].ipv4_address
  }

  ha_enabled = var.masters_count > 1 ? true : var.master_ha_enabled

  additional_apiserver_ports = var.master_apiserver_loadbalancer != "fip" ? [] : [
    443
  ]
}

resource "local_file" "hosts" {
  filename = abspath("${path.module}/../ansible/inventory/hosts.ini")

  content = templatefile("${path.module}/templates/hosts.ini", {
    private_network : hcloud_network.main,
    hcloud_token : var.hcloud_token_kubernetes,

    enabled_addons : var.enabled_addons,
    cni_type : var.cni_type,
    use_hetzner_loadbalancers : var.use_hetzner_loadbalancers,
    registries_config : var.registries_config,

    master_extra_args : var.master_extra_args,
    worker_extra_args : var.worker_extra_args,

    master_ha_enabled : local.ha_enabled,
    master_loadbalancer : var.master_apiserver_loadbalancer,
    master_advertise : var.master_apiserver_advertise,
    worker_master_connection : var.worker_master_connection != "" ? var.worker_master_connection : (local.ha_enabled ? "haproxy" : "first"),
    master_external_address : var.master_apiserver_external_address,

    master_internal_ip : local.apiserver_internal_ip_map[var.master_apiserver_loadbalancer],
    master_loadbalancer_fip_id : var.master_apiserver_loadbalancer == "fip" ? hcloud_floating_ip.apiserver_fip[0].id : 0,
    master_join_token : random_string.master_join_token.result,
    vrrp_password : random_string.vrrp_password.result,

    ssh_port : var.ssh_port,
    open_tcp_ports : setunion(var.additional_open_tcp_ports, local.additional_apiserver_ports, [
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

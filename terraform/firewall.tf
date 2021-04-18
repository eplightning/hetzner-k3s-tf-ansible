locals {
  hcloud_firewall_enabled    = (var.firewall_setup == "hcloud" || var.firewall_setup == "both")
}

resource "hcloud_firewall" "firewall" {
  count  = local.hcloud_firewall_enabled ? 1 : 0
  name   = "kube-firewall"
  labels = var.labels

  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  dynamic "rule" {
    for_each = setunion(var.additional_open_tcp_ports, local.additional_apiserver_ports, [
      var.ssh_port
    ])
    content {
      direction  = "in"
      protocol   = "tcp"
      port       = tostring(rule.value)
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    }
  }

  dynamic "rule" {
    for_each = var.additional_open_udp_ports
    content {
      direction  = "in"
      protocol   = "udp"
      port       = tostring(rule.value)
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    }
  }

}

variable "hcloud_token_kubernetes" {
  type        = string
  description = "Hetzner Cloud API token to be used by various applications running inside cluster (CPI, CSI, IP Floater)"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key name to be used for provisioned servers. Must already exist"
}

variable "location" {
  type        = string
  description = "Hetzner location (e.g. fsn1) for servers, networks"
}

variable "labels" {
  type        = map
  default     = {}
  description = "Optional labels for created Hetzner resources"
}

variable "master_server_type" {
  type        = string
  description = "Master server type (e.g. cpx11)"
}

variable "worker_server_type" {
  type        = string
  description = "Workers server type (e.g. cpx11)"
}

variable "masters_count" {
  type        = number
  description = "How many master servers to provision"
}

variable "workers_count" {
  type        = number
  description = "How many worker servers to provision"
}

variable "fips_count" {
  type        = number
  description = "How many floating IPs to provision. Used by MetalLB addon"
}

variable "ssh_port" {
  type        = number
  default     = 22
  description = "SSH port to use for servers"
}

variable "additional_open_tcp_ports" {
  type        = list(number)
  default     = [6443]
  description = "Additional TCP ports to open. SSH port will be appended unconditionally"
}

variable "additional_open_udp_ports" {
  type        = list(number)
  default     = []
  description = "Additional UDP ports to open"
}

variable "cni_type" {
  type = string
  default = "embedded"
  description = "Which CNI plugin to use. Supported: embedded (flannel), calico"
}

variable "use_hetzner_loadbalancers" {
  type = bool
  default = true
  description = "Use Hetzner Load Balancers. This conflicts with MetalLB"
}

variable "enabled_addons" {
  type        = list(string)
  default     = ["contour", "cert-manager", "csi"]
  description = "Which addons to install. Supported: contour, cert-manager, metallb, csi"
}

variable "master_ha_enabled" {
  type = bool
  default = true
  description = "Setup K3s in HA mode. If true, etcd datastore will be used instead of sqlite. Will be forced to true if masters_count > 1"
}

variable "master_apiserver_loadbalancer" {
  type = string
  default = "none"
  description = "What kind of apiserver loadbalancing to use. Supported: hetznerlb, fip, privatenetwork, none"
}

variable "master_apiserver_advertise" {
  type = string
  default = "privateip"
  description = "Which address should master servers advertise as. Supported: privateip, loadbalancer"
}

variable "master_apiserver_external_address" {
  type = string
  default = ""
  description = "Additional hostname that will be added to k3s apiserver TLS certificates"
}

variable "worker_master_connection" {
  type = string
  default = ""
  description = "How should workers connect to master servers. Will try to guess if not provided. Supported: loadbalancer, haproxy, first"
}




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
  description = "How many floating IPs to provision. Used by MetalLB for LoadBalancer services"
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
  description = "Which CNI plugin to use. Supported: embedded, calico"
}

variable "loadbalancer_type" {
  type = string
  default = "hetzner"
  description = "Which Kubernetes LoadBalancer implementation to use. Supported: hetzner, metallb, none"
}

variable "apiserver_datastore" {
  type = string
  default = "etcd"
  description = "Which datastore to use for Kubernetes, etcd will be forced in case of multi-master setup. Supported: etcd, sqlite"
}

variable "apiserver_external_hostname" {
  type        = string
  default     = ""
  description = "Optional additional hostname for API server. Will be added to TLS certificate"
}

variable "apiserver_loadbalancer_type" {
  type = string
  default = "fip"
  description = "Which api-server LoadBalancer implementation to use. Supported: loadbalancer, fip, none"
}

variable "enabled_addons" {
  type        = list(string)
  default     = ["contour", "cert-manager"]
  description = "Which addons to install. Supported: contour, cert-manager"
}

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

variable "master_external_hostname" {
  type        = string
  default     = ""
  description = "Optional additional hostname for master server. Will be used for RDNS setup"
}

variable "labels" {
  type        = map
  default     = {}
  description = "Optional labels for created Hetzner resources"
}

variable "master_server_type" {
  type        = string
  default     = "cpx11"
  description = "Master server type (e.g. cpx11)"
}

variable "worker_server_type" {
  type        = string
  default     = "cpx11"
  description = "Workers server type (e.g. cpx11)"
}

variable "workers_count" {
  type        = number
  default     = 1
  description = "How many worker servers to provision"
}

variable "fips_count" {
  type        = number
  default     = 1
  description = "How many floating IPs to provision"
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

variable "enabled_addons" {
  type        = list(string)
  default     = ["metallb", "contour", "cert-manager"]
  description = "Which addons to install. Supported: metallb, contour, cert-manager"
}

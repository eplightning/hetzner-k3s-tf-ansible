terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    local = {
      source = "hashicorp/local"
    }
  }
  required_version = ">= 0.13"
}

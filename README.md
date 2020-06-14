# hetzner-k3s-tf-ansible

Terraform and Ansible setup for provisioning K3s cluster using Hetzner Cloud infrastructure.

## Features

- Ubuntu 20.04, k3s 1.18.3,

- flannel CNI (host-gw) + k3s NetworkPolicy controller, using Hetzner's Private Network for node-to-node traffic,

- Full PV support using Hetzner Volumes (via CSI driver) or k3s local volume provisioner,

- Full LoadBalancer services support thanks to MetalLB and HCloud IP Floater. If you don't want to pay for Floating IPs - NodePorts still work pretty well,

- Basic firewall setup to protect provisioned instances (since Hetzner Cloud doesn't have Firewall / Security Groups yet),

- Support for various optional addons:
    - MetalLB + HCloud IP Floater,
    - Contour Ingress Controller,
    - cert-manager.

## Requirements

- Terraform 0.12,

- Ansible 2.9 (might work on older versions, not tested),

- Hetzner Cloud API key,

- SSH key registered in Hetzner Cloud.

## Quickstart

```
export HCLOUD_TOKEN="YOUR HETZNER TOKEN"

cd terraform
terraform apply

cd ../ansible
ansible-playbook -i inventory/hosts.ini cluster-setup.yml
```

## Customization

Available Terraform variables are defined in `terraform/variables.tf` file.

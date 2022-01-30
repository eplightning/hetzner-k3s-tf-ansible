# hetzner-k3s-tf-ansible

Terraform and Ansible setup for provisioning a K3s cluster using Hetzner Cloud infrastructure.

## Features

- Ubuntu 20.04, k3s 1.23,

- Multiple supported CNI's:
  - calico 3.21, using Hetzner's Private Network for node-to-node traffic,
  - built-in flannel CNI (host-gw) + k3s NetworkPolicy controller, using Hetzner's Private Network for node-to-node traffic,

- Support for HA control plane setups (Optional),
  - k3s with embedded etcd,
  - Every master node runs all control plane components (etcd, apiserver, scheduler, controller-manager),
  - Multiple options for external HA access to apiserver:
    - Hetzner Loadbalancer,
    - Keepalived + HAProxy + Hetzner Floating IP,
    - Keepalived + HAProxy + private network (only inside private network),
    - None (if you want to use DNS or don't need HA for external clients),

- Full PV support using Hetzner Volumes (via CSI driver, optional addon) or k3s local volume provisioner,

- Full LoadBalancer services support, using one of two options:
  - Hetzner Load Balancer
  - Hetzner Floating IP - using MetalLB + HCloud IP Floater

- Basic firewall setup to protect provisioned instances, supported options include:
  - Hetzner Cloud Firewall,
  - iptables setup on nodes,
  - Both of them at once or none of them.

- Support for various optional addons:
    - MetalLB + HCloud IP Floater

- Support for upgrading and scaling up the master/worker nodes

## Requirements

- Terraform 0.13 or newer (tested on 1.1),

- Ansible 2.9 or newer,

- Hetzner Cloud API key,

- SSH key registered in Hetzner Cloud.

## Quickstart

Copy `examples/example.tfvars` to `terraform/terraform.tfvars`. Customize it as needed, then provision cluster using:

```
export HCLOUD_TOKEN="YOUR HETZNER TOKEN"

cd terraform
terraform apply

cd ../ansible
ansible-playbook -i inventory/hosts.ini cluster-setup.yml
```

## Customization

Available Terraform variables are defined in `terraform/variables.tf` file.
Example configurations are available in `examples` directory.

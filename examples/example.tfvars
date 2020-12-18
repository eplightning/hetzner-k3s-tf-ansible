#
# CORE OPTIONS
#

hcloud_token_kubernetes = ""
ssh_port = 22

master_server_type = "cpx11"
worker_server_type = "cpx11"
masters_count = 2
workers_count = 1

location = "hel1"

# Needs to be added manually in Hetzner Console
ssh_key_name = "user@host"

labels = {
  "manager": "terraform",
  "cluster": "k3s"
}

additional_open_tcp_ports = [
  6443
]
additional_open_udp_ports = [
  40000
]

#
# CUSTOMIZATION
#

# CNI to install: [embedded|calico]
# - embedded - embedded flannel
# - calico - calico without BIRD backend (using private networks routing)
cni_type = "calico"

# Mutually exclusive with metallb addon
use_hetzner_loadbalancers = false

# Number of floating IPs to provision for use in metallb addon
fips_count = 1

# List of addons to install, available:
# - contour
# - cert-manager
# - csi
# - metallb (CANNOT BE USED WITH use_hetzner_loadbalancers=true)
enabled_addons = ["contour", "cert-manager", "csi", "metallb"]

#
# HA OPTIONS
#

# If false and masters_count is 1, this option will force use of sqlite datastore backend
# Datastore migration is currently unsupported so if you're planning on adding more master nodes later, set this option to true to force etcd
master_ha_enabled = true

# Additional external address to be appended to apiserver TLS certificates, empty if not needed
master_apiserver_external_address = "some-extra.domain.com"

# Defines how worker nodes will connect to master nodes:
# haproxy - HIGHLY RECOMMENDED (default) - setups node-local loadbalancers on worker nodes
# loadbalancer - connects via provisioned loadbalancer (depending on master_apiserver_loadbalancer)
# first - connects to first master only - only makes sense for non-HA setups
worker_master_connection = "haproxy"

# Use `none` if you don't need HA for clients accessing apiserver OUTSIDE of cluster. Even in that case you can still provide decent HA by using standard DNS (but that's outside of this project's scope).
# If you do need HA for external clients, supported options are:
# - `hetznerlb` - uses Hetzner Cloud Load Balancer to provide HA
# - `fip` - setups keepalived + haproxy on master nodes, uses Hetzner Cloud Floating IP to provide HA
# - `privatenetwork` - same as above but uses private network aliases instead of Floating IP, useful if you only care about clients accessing through private network
master_apiserver_loadbalancer = "none"

# UNSUPPORTED for now, `loadbalancer` option has issues. Use `privateip` option for standard ClusterIP loadbalancing of cluster internal kube-apiserver traffic
# master_apiserver_advertise = "privateip"







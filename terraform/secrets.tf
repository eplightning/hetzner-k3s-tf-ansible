resource "random_string" "master_join_token" {
  length = 32
  special = false
}

resource "random_string" "vrrp_password" {
  length = 8
  special = false
}

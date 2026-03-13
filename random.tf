resource "random_password" "master_password" {
  count   = var.create_master_password ? 1 : 0
  length  = 16
  special = false
}
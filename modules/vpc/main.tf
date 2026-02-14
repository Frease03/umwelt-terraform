resource "digitalocean_vpc" "this" {
  name     = format("%s-vpc", var.project)
  region   = var.region
  ip_range = var.ip_range
}


output "vpc_id" {
  value = digitalocean_vpc.this.id
}
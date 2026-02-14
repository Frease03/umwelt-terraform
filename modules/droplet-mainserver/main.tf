resource "digitalocean_droplet" "main_server" {
  name        = "main-server"
  size        = "s-8vcpu-16gb"
  image       = "ubuntu-22-04-x64"
  region      = var.region
  vpc_uuid    = var.vpc_id
  tags        = ["main-server", "app", "production", "docker"]
  monitoring  = true
  backups     = false

  
  ipv6               = false

  user_data = templatefile("${path.module}/user_data.sh", {
    database_private_ip = var.database_private_ip
    monitoring_ip       = var.monitoring_private_ip
  })

  ssh_keys = var.ssh_keys
}

resource "digitalocean_floating_ip" "main_server" {
  droplet_id = digitalocean_droplet.main_server.id
  region     = var.region
}
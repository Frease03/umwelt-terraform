resource "digitalocean_droplet" "load_balancer" {
  name        = "load-balancer"
  size        = "s-2vcpu-4gb"
  image       = "ubuntu-22-04-x64"
  region      = var.region
  vpc_uuid    = var.vpc_id
  tags        = ["load-balancer", "nginx", "production", "docker"]
  monitoring  = true
  backups     = false

  ipv6               = false

  user_data = templatefile("${path.module}/user_data.sh", {
    main_server_private_ip = var.main_server_private_ip
    domain_name            = var.domain_name
  })

  ssh_keys = var.ssh_keys
}

resource "digitalocean_floating_ip" "load_balancer" {
  droplet_id = digitalocean_droplet.load_balancer.id
  region     = var.region
}
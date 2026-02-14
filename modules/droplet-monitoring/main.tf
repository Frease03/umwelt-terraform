resource "digitalocean_droplet" "monitoring" {
  count    = var.droplet_count
  image    = var.image
  name     = "${var.name}-${count.index + 1}"
  region   = var.region
  size     = var.size
  vpc_uuid = var.vpc_id
  tags     = var.tags
  ssh_keys = var.ssh_keys

   # SSH connection for remote-exec
  connection {
    type          = "ssh"
    host          = self.ipv4_address
    user          = "root"
    private_key   = file(var.private_key_path)
    timeout       = "5m"
    agent         = false
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Monitoring droplet setup complete!'"
    ]
  }
}
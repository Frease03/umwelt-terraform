resource "digitalocean_droplet" "database" {
  count    = var.droplet_count
  image    = var.image
  name     = "${var.name}-${count.index + 1}"
  region   = var.region
  size     = var.size
  vpc_uuid = var.vpc_id
  tags     = var.tags
  ssh_keys = var.ssh_keys

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.private_key_path)
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Database droplet ${var.name}-${count.index + 1} is ready'"
    ]
  }
}


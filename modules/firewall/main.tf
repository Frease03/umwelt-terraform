resource "digitalocean_firewall" "umwelt_firewall" {
  name = "umwelt-firewall"

  # Allow traffic from Load Balancer to Main Server (ports 80/443)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = [var.load_balancer_private_ip]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = [var.load_balancer_private_ip]
  }

  # Allow traffic from Main Server to Database (port 5432)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "5432"
    source_addresses = [var.main_server_private_ip]
  }

  # Public access to Load Balancer (HTTP/HTTPS)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Public access to CI/CD endpoints (SSH and CI ports)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Internal monitoring traffic
  inbound_rule {
    protocol         = "tcp"
    port_range       = "9090"
    source_addresses = values(var.private_ips)
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "3000"
    source_addresses = values(var.private_ips)
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "9100"
    source_addresses = values(var.private_ips)
  }

  # Outbound rules - allow all
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  droplet_ids = values(var.droplet_ids)
}
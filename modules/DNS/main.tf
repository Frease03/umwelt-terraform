resource "digitalocean_domain" "main" {
  name = var.domain_name
}

# Main domain points to Load Balancer Floating IP
resource "digitalocean_record" "root" {
  domain = digitalocean_domain.main.name
  type   = "A"
  name   = "@"
  value  = var.lb_ip
  ttl    = 300
}

# WWW subdomain
resource "digitalocean_record" "www" {
  domain = digitalocean_domain.main.name
  type   = "A"
  name   = "www"
  value  = var.lb_ip
  ttl    = 300
}

# API subdomain
resource "digitalocean_record" "api" {
  domain = digitalocean_domain.main.name
  type   = "A"
  name   = "api"
  value  = var.lb_ip
  ttl    = 300
}

# Direct main server access (using floating IP)
resource "digitalocean_record" "direct" {
  domain = digitalocean_domain.main.name
  type   = "A"
  name   = "direct"
  value  = var.main_ip
  ttl    = 300
}
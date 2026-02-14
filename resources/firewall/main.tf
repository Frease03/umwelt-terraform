locals {
  env = merge(
    yamldecode(file("${path.module}/../../environments/variables.yaml"))
  )
}

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
  terraform {
  backend "s3" {
    bucket                      = "umwelt-backend"       # your DO Space name
    key                         = "firewall/terraform/state"       # path to state file
    region                      = "us-east-1"             # AWS region placeholder (required but ignored by DO)
    endpoints = {
      s3 = "https://nyc3.digitaloceanspaces.com"
    }
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    access_key                  = var.do_access_key
    secret_key                  = var.do_secret_key
  }
}

module "firewall" {
  source = "../../modules/firewall"

  do_token                  = local.env.firewall.do_token
  vpc_id                     = local.env.firewall.vpc_id
  name                        = local.env.firewall.name
  inbound_rules               = local.env.firewall.inbound_rules != null ? local.env.firewall.inbound_rules : []
  outbound_rules              = local.env.firewall.outbound_rules != null ? local.env.firewall.outbound_rules : []
  droplet_ids                 = local.env.firewall.droplet_ids != null ? local.env.firewall.droplet_ids : {}
  private_ips                 = local.env.firewall.private_ips != null ? local.env.firewall.private_ips : {}
  load_balancer_private_ip    = local.env.firewall.load_balancer_private_ip
  main_server_private_ip      = local.env.firewall.main_server_private_ip
}

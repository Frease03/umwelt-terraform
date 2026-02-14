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
    key                         = "main-server/terraform/state"       # path to state file
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


module "droplet_mainserver" {
  source = "../../modules/droplet-mainserver"

  # Pass the token if your module supports it
  do_token = local.env.droplet_mainserver.do_token

  # Access values using dot notation
  name              = local.env.droplet_mainserver.name
  droplet_count     = local.env.droplet_mainserver.count
  region            = local.env.droplet_mainserver.region
  size              = local.env.droplet_mainserver.size
  image             = local.env.droplet_mainserver.image
  vpc_id            = local.env.droplet_mainserver.vpc_id
  ssh_keys          = local.env.droplet_mainserver.ssh_keys
  private_key_path  = local.env.droplet_mainserver.private_key_path
  app_port          = local.env.droplet_mainserver.app_port
  tags              = local.env.droplet_mainserver.tags

  database_private_ip   = local.env.droplet_mainserver.database_private_ip
  monitoring_private_ip = local.env.droplet_mainserver.monitoring_private_ip

}

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
    key                         = "loadbalancer/terraform/state"       # path to state file
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

module "droplet_loadbalancer" {
  source                  = "../../modules/droplet-loadbalancer"

  do_token = local.env.droplet_loadbalancer.do_token


  name                    = local.env.droplet_loadbalancer.name
  droplet_count           = local.env.droplet_loadbalancer.count
  region                  = local.env.droplet_loadbalancer.region
  size                    = local.env.droplet_loadbalancer.size
  image                   = local.env.droplet_loadbalancer.image
  vpc_id                  = local.env.droplet_loadbalancer.vpc_id
  ssh_keys                = local.env.droplet_loadbalancer.ssh_keys
  tags                    = local.env.droplet_loadbalancer.tags
  health_check_port       = local.env.droplet_loadbalancer.health_check_port
  project_name            = local.env.project_name
  private_key_path        = local.env.droplet_loadbalancer.private_key_path
  domain_name             = local.env.droplet_loadbalancer.domain_name
  main_server_private_ip  = local.env.droplet_loadbalancer.main_server_private_ip
}



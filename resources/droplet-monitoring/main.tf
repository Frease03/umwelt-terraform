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
    key                         = "monitoring/terraform/state"       # path to state file
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


module "droplet_monitoring" {
  source   = "../../modules/droplet-monitoring"
  tags     = local.env.droplet_monitoring.tags
  name     = local.env.droplet_monitoring.name
  droplet_count   = local.env.droplet_monitoring.droplet_count
  region   = local.env.droplet_monitoring.region
  size     = local.env.droplet_monitoring.size
  image    = local.env.droplet_monitoring.image
  vpc_id   = local.env.droplet_monitoring.vpc_id
  ssh_keys = local.env.droplet_monitoring.ssh_keys
  private_key_path = local.env.droplet_monitoring.private_key_path
  allowed_cidr_blocks = local.env.droplet_monitoring.allowed_cidr_blocks
  app_port = local.env.droplet_monitoring.app_port
  project_name = local.env.droplet_monitoring.project_name
}


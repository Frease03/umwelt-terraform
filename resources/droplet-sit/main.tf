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
    key                         = "sit/terraform/state"       # path to state file
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

module "droplet-sit" {
  source   = "../../modules/droplet-sit"

  do_token = local.env.droplet_sit.do_token
  tags     = local.env.droplet_sit.tags
  name     = local.env.droplet_sit.name
  droplet_count   = local.env.droplet_sit.droplet_count
  region   = local.env.droplet_sit.region
  size     = local.env.droplet_sit.size
  image    = local.env.droplet_sit.image
  vpc_id   = local.env.droplet_sit.vpc_id
  ssh_keys = local.env.droplet_sit.ssh_keys
  private_key_path = local.env.droplet_sit.private_key_path
  app_port = local.env.droplet_sit.app_port
  project_name = local.env.droplet_sit.project_name
}


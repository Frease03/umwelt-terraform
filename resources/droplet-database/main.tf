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
    key                         = "database/terraform/state"       # path to state file
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

module "droplet_database" {
  source   = "../../modules/droplet-database"

  do_token = local.env.droplet_database.do_token

  name         = local.env.droplet_database.name
  droplet_count = local.env.droplet_database.count
  region       = local.env.droplet_database.region
  size         = local.env.droplet_database.size
  image        = local.env.droplet_database.image
  vpc_id       = local.env.droplet_database.vpc_id
  ssh_keys     = local.env.droplet_database.ssh_keys
  private_key_path = local.env.droplet_database.private_key_path
  project_name = local.env.project_name
  tags         = local.env.droplet_database.tags


}


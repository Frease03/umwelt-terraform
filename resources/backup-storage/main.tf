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
    key                         = "backup-storage/terraform/state"       # path to state file
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

module "backup-storage" {
  source   = "../../modules/backup-storage"
  volume_name = local.env.backup_storage.volume_name
  do_token = local.env.backup_storage.do_token
  volume_size = local.env.backup_storage.volume_size
  volume_description = local.env.backup_storage.volume_description
  volume_region = local.env.backup_storage.volume_region
  enable_backups = local.env.backup_storage.enable_backups
  
}

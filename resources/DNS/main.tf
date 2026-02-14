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
    key                         = "DNS/terraform/state"       # path to state file
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

module "DNS" {
  source   = "../../modules/DNS"
  domain_name = local.env.DNS.domain_name
  do_token    = local.env.DNS.do_token
  records     = local.env.DNS.records
  project     = local.env.DNS.Project
  lb_ip = local.env.DNS.lb_ip
  main_ip = local.env.DNS.main_ip
  

}

  
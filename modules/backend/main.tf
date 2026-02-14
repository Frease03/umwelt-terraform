terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  # Remote backend (Terraform state in DO Spaces)
  backend "s3" {
    endpoint   = "nyc3.digitaloceanspaces.com"   # region endpoint (example: nyc3, sgp1, ams3)
    bucket     = "umwelt-backend"           # your DO Space bucket
    key        = "infra/terraform.tfstate"       # path inside the bucket
    region     = "us-east-1"                     # AWS-style region, still required
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
variable "domain_name" {
  description = "Domain name"
  type        = string
}


variable "region" {
  description = "Region to create floating IPs"
  type        = string
  default     = "nyc3"
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "lb_ip" {
  description = "Load balancer floating IP"
  type        = string
}

variable "main_ip" {
  description = "Main server floating IP"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "records" {
  description = "DNS records for the domain"
  type = list(object({
    type = string
    name = string
    data = string
    ttl  = number
  }))
}
variable "name" {
  description = "Name prefix for the droplet"
  type        = string
  default     = "loadbalancer"
}

variable "do_token" {
  type        = string
  description = "DigitalOcean API token"
}

variable "droplet_count" {
  description = "Number of loadbalancer droplets to create"
  type        = number
  default     = 1
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc3"
}

variable "size" {
  description = "Droplet size"
  type        = string
  default     = "s-2vcpu-4gb"  # 4GB RAM, 2 vCPUs
}

variable "image" {
  description = "Droplet image"
  type        = string
  default     = "ubuntu-22-04-x64"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "Tags for the droplet"
  type        = list(string)
  default     = ["loadbalancer", "nginx", "haproxy"]
}

variable "ssh_keys" {
  description = "List of SSH key IDs or fingerprints"
  type        = list(string)
}

variable "private_key_path" {
  description = "Path to the private key for SSH access"
  type        = string
}

variable "health_check_port" {
  description = "Health check port for load balancer"
  type        = string
  default     = "8080"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "umwelt_project"
}

variable "main_server_private_ip" {
  description = "Main server private IP"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}
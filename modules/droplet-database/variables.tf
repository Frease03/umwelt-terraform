variable "name" {
  description = "Name prefix for the droplet"
  type        = string
  default     = "database"
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "droplet_count" {
  description = "Number of database droplets to create"
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
  default     = "s-4vcpu-8gb"  # 8GB RAM, 4 vCPUs
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
  default     = ["database", "postgresql", "redis"]
}

variable "ssh_keys" {
  description = "List of SSH key IDs or fingerprints"
  type        = list(string)
}

variable "private_key_path" {
  description = "Path to the private key for SSH access"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access database ports"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "umwelt_project"
}
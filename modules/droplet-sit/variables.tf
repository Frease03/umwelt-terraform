variable "name" {
  description = "Name prefix for the droplet"
  type        = string
  default     = "sit"
}

variable "do_token" {
  type        = string
  description = "DigitalOcean API token"
}

variable "droplet_count" {
  description = "Number of SIT droplets to create"
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
  default     = ["sit", "testing", "staging"]
}

variable "ssh_keys" {
  description = "List of SSH key IDs or fingerprints"
  type        = list(string)
}

variable "private_key_path" {
  description = "Path to the private key for SSH access"
  type        = string
}

variable "app_port" {
  description = "Application port"
  type        = string
  default     = "3000"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "umwelt-project"
}
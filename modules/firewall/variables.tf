variable "vpc_id" {
  description = "VPC ID for the firewall"
  type        = string
}

variable "do_token" {
  type        = string
  description = "DigitalOcean API token"
}

variable "droplet_ids" {
  description = "Map of droplet IDs to apply firewall rules to"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Firewall name"
  type        = string
}

variable "inbound_rules" {
  description = "List of inbound rules"
  type        = any
}

variable "outbound_rules" {
  description = "List of outbound rules"
  type        = any
}

variable "private_ips" {
  description = "Map of private IP addresses for each droplet"
  type        = map(string)
  default     = {}
}

variable "load_balancer_private_ip" {
  description = "Private IP address of the load balancer droplet"
  type        = string
}

variable "main_server_private_ip" {
  description = "Private IP address of the main server droplet"
  type        = string
}
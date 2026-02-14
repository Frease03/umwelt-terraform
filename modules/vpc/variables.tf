variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Region to deploy the VPC"
  type        = string
  default     = "nyc3"
}

variable "ip_range" {
  description = "Private IP range for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the VPC"
  default = {}
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "name" {
  description = "Name of the VPC"
  type        = string
  default     = "umwelt-vpc"
}

variable "description" {
  description = "Description of the VPC"
  type        = string
  default     = "VPC for Umwelt application"
}


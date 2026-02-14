variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "volume_name" {
  description = "Name for the block storage volume"
  type        = string
  default     = "umwelt-backup-storage"
}

variable "volume_size" {
  description = "Size of the volume in GB"
  type        = number
  default     = 100
}

variable "volume_region" {
  description = "DigitalOcean region for the volume"
  type        = string
  default     = "nyc3"
}

variable "volume_description" {
  description = "Description for the volume"
  type        = string
  default     = "100GB backup storage for Betpeer application"
}

variable "enable_backups" {
  description = "Enable automatic backups for the volume"
  type        = bool
  default     = true
}
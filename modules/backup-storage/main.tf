# Create the block storage volume
resource "digitalocean_volume" "backup_storage" {
  region                   = var.volume_region
  name                     = var.volume_name
  size                     = var.volume_size
  description              = var.volume_description
  
}

# Output the volume information
output "volume_id" {
  description = "ID of the created volume"
  value       = digitalocean_volume.backup_storage.id
}

output "volume_urn" {
  description = "URN of the created volume"
  value       = digitalocean_volume.backup_storage.urn
}


output "volume_size" {
  description = "Size of the volume in GB"
  value       = digitalocean_volume.backup_storage.size
}
output "zone_id" {
  value = module.zone.zone_id
}

output "zone_name" {
  value = module.zone.zone_name
}

output "record" {
  description = "FQDNs of created records"
  value       = module.zone.record
}

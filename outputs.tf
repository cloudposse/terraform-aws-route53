output "zone_id" {
  description = "ID of created zone"
  value       = local.enabled ? aws_route53_zone.default[0].zone_id : null
}

output "zone_name" {
  description = "Name of created zone"
  value       = var.zone_name
}

output "record" {
  description = "FQDNs of created records"
  value       = { for k, v in aws_route53_record.default : k => v.fqdn }
}

output "name_servers" {
  description = "A list of name servers in associated (or default) delegation set"
  value       = local.enabled ? aws_route53_zone.default[0].name_servers : null
}
output "zone_id" {
  description = "ID of created zone"
  value       = aws_route53_zone.default.zone_id
}

output "zone_name" {
  description = "Name of created zone"
  value       = aws_route53_zone.default.name
}

output "record" {
  description = "FQDNs of created records"
  value       = { for k, v in aws_route53_record.default : k => v.fqdn }
}
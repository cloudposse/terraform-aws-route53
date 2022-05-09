locals {
  enabled = module.this.enabled

  records = try(jsondecode(var.records), var.records)
  record_objects = {
    for i, r in local.records :
    join("_", compact([
      try(lower(r.name), ""),
      lower(r.type),
      try(lower(r.set_identifier), ""),
      try(lower(r.failover), "")
      ])) => {
      name    = try(lower(r.name), "")
      type    = r.type
      ttl     = try(r.ttl, null)
      records = try(r.records, null)
      alias = {
        name                   = try(r.alias.name, null)
        zone_id                = try(r.alias.zone_id, null)
        evaluate_target_health = try(r.alias.evaluate_target_health, null)
      }
      geolocation = {
        continent   = try(r.geolocation.continent, null)
        country     = try(r.geolocation.country, null)
        subdivision = try(r.geolocation.subdivision, null)
      }
      allow_overwrite = try(r.allow_overwrite, var.allow_overwrite)
      health_check_id = try(r.health_check_id, null)
      set_identifier  = try(r.set_identifier, null)
      weight          = try(r.weight, null)
      failover        = try(r.failover, null)
    }
  }
}

resource "aws_route53_zone" "default" {
  count = local.enabled ? 1 : 0

  name          = var.zone_name
  comment       = module.this.name
  force_destroy = var.force_destroy

  tags = module.this.tags
}

resource "aws_route53_record" "default" {
  for_each = local.record_objects

  zone_id         = aws_route53_zone.default[0].zone_id
  type            = each.value.type
  name            = each.value.name
  allow_overwrite = var.allow_overwrite
  health_check_id = try(each.value.health_check_id, null)
  set_identifier  = try(each.value.set_identifier, null)

  # If the TTL wasn't set and the record type is not an alias, then use the default TTL
  ttl = each.value.alias.name == null ? coalesce(each.value.ttl, var.default_ttl) : null

  # Split TXT records which have a size of more than 255 chars
  records = each.value.records != null ? [for r in each.value.records :
    each.value.type == "TXT" && length(regexall("(\\\"\\\")", r)) == 0 ?
    replace(r, "/(.{255})/", "$1\"\"") : r
  ] : null

  dynamic "alias" {
    for_each = each.value.alias.name == null ? [] : [each.value.alias]

    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = coalesce(
      each.value.geolocation.continent,
      each.value.geolocation.country,
    each.value.geolocation.subdivision, "empty") == "empty" ? [] : [each.value.geolocation]

    content {
      continent   = geolocation_routing_policy.value.continent
      country     = geolocation_routing_policy.value.country
      subdivision = geolocation_routing_policy.value.subdivision
    }
  }

  dynamic "weighted_routing_policy" {
    for_each = each.value.weight == null ? [] : [each.value.weight]

    content {
      weight = weighted_routing_policy.value
    }
  }

  dynamic "failover_routing_policy" {
    for_each = each.value.failover == null ? [] : [each.value.failover]

    content {
      type = failover_routing_policy.value.type
    }
  }
}

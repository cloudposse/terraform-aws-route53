variable "zone_name" {
  type        = string
  default     = null
  description = "Name of the Route53 hosted zone. Must be an valid FQDN."
}

variable "records" {
  type        = any
  default     = []
  description = "Records set for the hosted zone to create"
}

variable "default_ttl" {
  type        = number
  default     = 3600
  description = "Default Time To Live (TTL) for records, when not explicitly defined in the records set"
}

variable "allow_overwrite" {
  type        = bool
  default     = false
  description = "Allow overwriting existing records"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Set to true if you want to remove all records in the zone. Not recommended as some records may be created outside the terraform (e.g. such as from the `external-dns` controller)"
}

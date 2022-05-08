variable "region" {
  type        = string
  description = "AWS region"
  default = "us-east-2"
}

variable "zone_name" {
  type = string
}

variable "records" {
  type = any
}
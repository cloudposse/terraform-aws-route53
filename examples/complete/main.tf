module "zone" {
  source  = "../../"
  context = module.this.context

  zone_name = var.zone_name

  records = var.records
}
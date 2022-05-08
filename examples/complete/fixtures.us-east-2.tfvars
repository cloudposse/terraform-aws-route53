region = "us-east-2"

namespace = "eg"

environment = "ue2"

stage = "test"

zone_name = "cloudposse-terraform-aws-route53.cloudposse.com"

records = [
  {
    name = "a-record"
    type = "A"
    ttl  = 600

    records = [
      "10.0.0.1",
      "10.0.0.2"
    ]
  },
  {
    name    = "cname-record"
    type    = "CNAME"
    ttl     = 600

    records = ["a-record"]
  },
  {
    name = "txt-record"
    type = "TXT"
    ttl = 300

    records = ["v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAraC3pqvqTkAfXhUn7Kn3JUNMwDkZ65ftwXH58anno/bElnTDAd/idk8kWpslrQIMsvVKAe+mvmBEnpXzJL+0LgTNVTQctUujyilWvcONRd/z37I34y6WUIbFn4ytkzkdoVmeTt32f5LxegfYP4P/w7QGN1mOcnE2Qd5SKIZv3Ia1p9d6uCaVGI8brE/7zM5c/zMthVPE2WZKA28+QomQDH7ludLGhXGxpc7kZZCoB5lQiP0o07Ful33fcED73BS9Bt1SNhnrs5v7oq1pIab0LEtHsFHAZmGJDjybPA7OWWaV3L814r/JfU2NK1eNu9xYJwA8YW7WosL45CSkyp4QeQIDAQAB"]
  },
  {
    name = "weighted-record"
    type = "CNAME"

    set_identifier = "weighted-record-90"
    weight = 90

    records = ["a-record"]
  },
  {
    name = "weighted-record"
    type = "CNAME"

    set_identifier = "weighted-record-10"
    weight = 10

    records = ["cname-record"]
  },
  {
    name = "failover-record"
    type = "CNAME"

    set_identifier = "failover-record-primary"
    health_check_id = "dce171f0-cecc-11ec-9d64-0242ac120002"
    failover = {
      type = "PRIMARY"
    }

    records = ["weighted-record"]
  },
  {
    name = "failover-record"
    type = "CNAME"

    set_identifier = "failover-record-secondary"
    failover = {
      type = "SECONDARY"
    }

    records = ["weighted-record"]
  },
  {
    name = "geo-record"
    type = "CNAME"
    
    set_identifier = "geo-record-US"
    geolocation = {
      country = "US"
    }

    records = ["failover-record"]
  },
  {
    name = "geo-record"
    type = "CNAME"

    set_identifier = "geo-record-UA"
    geolocation = {
      country = "UA"
    }

    records = ["failover-record"]
  }

]

# DNS - Route53
# - creation on a RR api.<DOMAIN> with weighted policy

data "aws_route53_zone" "lab" {
  provider = "aws.primary"
  name     = "${var.dns_domain}"
}

# Route53 on first region
resource "aws_route53_record" "api-region1" {
  provider = "aws.primary"
  zone_id  = "${data.aws_route53_zone.lab.zone_id}"
  name     = "api"
  type     = "CNAME"
  ttl      = "5"

  weighted_routing_policy {
    weight = 50
  }

  set_identifier = "region1"
  records        = ["${module.api-gateway_region1.api-gateway_url}"]
}

# Route53 on second region
resource "aws_route53_record" "api-region2" {
  provider = "aws.primary"
  zone_id  = "${data.aws_route53_zone.lab.zone_id}"
  name     = "api"
  type     = "CNAME"
  ttl      = "5"

  weighted_routing_policy {
    weight = 50
  }

  set_identifier = "region2"
  records        = ["${module.api-gateway_region2.api-gateway_url}"]
}

# Print as ouput the API URL

output "api_url" {
  value = "api.${var.dns_domain}"
}

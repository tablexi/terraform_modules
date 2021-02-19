locals {
  domain_names_parts = {
    for domain in var.domain_names : domain => split(".", domain)
  }

  zone_names = {
    for domain, parts in local.domain_names_parts :
    domain => join(".", length(parts) > 2 ? slice(parts, 1, length(parts)) : parts)
  }
}

data "aws_route53_zone" "validation_zones" {
  for_each = toset(values(local.zone_names))

  name = each.value
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = var.domain_names[0]
  subject_alternative_names = slice(var.domain_names, 1, length(var.domain_names))
  validation_method         = "DNS"
}

resource "aws_route53_record" "validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.validation_zones[local.zone_names[each.key]].zone_id
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_records : record.fqdn]
}

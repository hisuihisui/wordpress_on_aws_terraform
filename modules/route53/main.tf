resource "aws_route53_zone" "hostzone" {
  name = var.domain
}

resource "aws_route53_record" "alb_alias" {
  zone_id = aws_route53_zone.hostzone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.alb_parameter.dns_name
    zone_id                = var.alb_parameter.zone_id
    evaluate_target_health = true
  }
}

# ACMでSSL証明書を作成
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"
  subject_alternative_names = ["*.${var.domain}"]

  lifecycle {
    create_before_destroy = true
  }
}

# SSL証明書の検証
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = flatten([values(aws_route53_record.cert)[*].fqdn])
}

# SSL証明書のDNS検証用レコード
resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  zone_id = aws_route53_zone.hostzone.zone_id
  ttl     = 60
}

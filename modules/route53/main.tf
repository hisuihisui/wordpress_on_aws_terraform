resource "aws_route53_zone" "hostzone" {
  name = var.domain
}

resource "aws_route53_record" "alb_alias" {
  zone_id = aws_route53_zone.hostzone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.alb_parameter.dns_name
    zone_id                = var.alb_parameter.main.zone_id
    evaluate_target_health = true
  }
}

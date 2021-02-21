data "aws_route53_zone" "domain_zone" {
  name = var.domain
}

resource "aws_route53_record" "tabwriter_app_record" {
  zone_id = data.aws_route53_zone.domain_zone.zone_id
  name    = var.domain
  type    = "A"
  ttl     = "60"
  records = [aws_instance.tabwriter_instance.public_ip]
}

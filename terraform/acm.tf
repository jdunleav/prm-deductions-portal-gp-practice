resource "aws_acm_certificate" "gp-portal-certificate" {
  domain_name       = "${var.environment}.patient-deductions.nhs.uk"
  validation_method = "DNS"
}

resource "aws_route53_record" "gp-portal-cert-validation-record" {
  name    = aws_acm_certificate.gp-portal-certificate.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.gp-portal-certificate.domain_validation_options.0.resource_record_type
  zone_id = data.aws_ssm_parameter.root_zone_id.value
  records = [aws_acm_certificate.gp-portal-certificate.domain_validation_options.0.resource_record_value]
  ttl     = "60"
}

resource "aws_acm_certificate_validation" "default" {
  certificate_arn = aws_acm_certificate.gp-portal-certificate.arn
  validation_record_fqdns = [
    aws_route53_record.gp-portal-cert-validation-record.fqdn
  ]
}
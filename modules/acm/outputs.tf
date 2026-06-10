output "certificate_arn" {
  description = "ARN do certificado ACM"
  value       = aws_acm_certificate.this.arn
}

output "zone_id" {
  description = "ID da hosted zone do Route53"
  value       = data.aws_route53_zone.this.zone_id
}

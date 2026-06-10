output "target_group_arn" {
  description = "ARN do target group"
  value       = aws_lb_target_group.this.arn
}

output "alb_dns_name" {
  description = "DNS name do ALB"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Hosted Zone ID do ALB (para alias record)"
  value       = aws_lb.this.zone_id
}

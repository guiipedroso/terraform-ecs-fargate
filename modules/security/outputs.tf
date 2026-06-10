output "alb_sg_id" {
  description = "ID do security group do ALB"
  value       = aws_security_group.alb.id
}

output "ecs_sg_id" {
  description = "ID do security group do ECS"
  value       = aws_security_group.ecs.id
}

output "ecs_execution_role_arn" {
  description = "ARN da IAM role de execução do ECS"
  value       = aws_iam_role.ecs_execution_role.arn
}

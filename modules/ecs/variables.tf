variable "private_subnet_1a_id" {
  description = "ID da subnet privada us-east-1a"
  type        = string
}

variable "private_subnet_1b_id" {
  description = "ID da subnet privada us-east-1b"
  type        = string
}

variable "ecs_sg_id" {
  description = "ID do security group do ECS"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN da IAM role de execução do ECS"
  type        = string
}

variable "target_group_arn" {
  description = "ARN do target group do ALB"
  type        = string
}

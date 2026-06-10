variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "public_subnet_1a_id" {
  description = "ID da subnet pública us-east-1a"
  type        = string
}

variable "public_subnet_1b_id" {
  description = "ID da subnet pública us-east-1b"
  type        = string
}

variable "alb_sg_id" {
  description = "ID do security group do ALB"
  type        = string
}

variable "certificate_arn" {
  description = "ARN do certificado ACM"
  type        = string
}

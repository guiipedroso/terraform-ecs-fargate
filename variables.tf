variable "domain" {
  description = "Domínio principal registrado no Route53 (ex: example.com)"
  type        = string
}

variable "role_arn" {
  description = "ARN da IAM Role para o Terraform assumir (deixe vazio para usar credenciais locais)"
  type        = string
  default     = ""
}

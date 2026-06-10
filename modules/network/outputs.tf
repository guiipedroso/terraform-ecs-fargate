output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_1a_id" {
  description = "ID da subnet pública us-east-1a"
  value       = aws_subnet.public_1a.id
}

output "public_subnet_1b_id" {
  description = "ID da subnet pública us-east-1b"
  value       = aws_subnet.public_1b.id
}

output "private_subnet_1a_id" {
  description = "ID da subnet privada us-east-1a"
  value       = aws_subnet.private_1a.id
}

output "private_subnet_1b_id" {
  description = "ID da subnet privada us-east-1b"
  value       = aws_subnet.private_1b.id
}

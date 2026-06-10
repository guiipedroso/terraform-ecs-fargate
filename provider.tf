provider "aws" {
  region = "us-east-1"

  dynamic "assume_role" {
    for_each = var.role_arn != "" ? [var.role_arn] : []
    content {
      role_arn = assume_role.value
    }
  }
}

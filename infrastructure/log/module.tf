resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 30
  tags = {
    Project = var.project
    Client  = var.client
  }
}

output "id" {
  value = aws_cloudwatch_log_group.main.id
}

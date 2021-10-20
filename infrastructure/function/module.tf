resource "aws_lambda_function" "main" {
  filename      = var.package
  function_name = "${var.name}-${var.project}-${var.client}"
  role          = var.role_arn
  handler       = var.handler
  package_type  = "Zip"
  memory_size   = var.memory
  runtime       = "python${var.python_version}"
  tags = {
    Project = var.project
    Client  = var.client
  }
}

output "name" {
  value = aws_lambda_function.main.function_name
}

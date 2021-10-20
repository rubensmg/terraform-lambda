resource "aws_iam_role" "main" {
  path = "/custom/${var.client}/${var.project}/"
  name = "rle-${var.project}-${var.client}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Project = var.project
    Client  = var.client
  }
}

resource "aws_iam_policy" "main" {
  name        = "plc-${var.project}-${var.client}"
  path        = "/custom/${var.client}/${var.project}/"
  description = "IAM policy for logging operations from a lambda"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
        Sid      = "logs"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Sid      = "network"
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
  depends_on = [
    aws_iam_policy.main,
    aws_iam_role.main
  ]
}


output "arn" {
  value = aws_iam_role.main.arn
}

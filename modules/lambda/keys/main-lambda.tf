variable "solutionsnplusone_subnets" {}
variable "stage_name" {}
variable "layer" {}
variable "public_vpc_solutionsnplusone" {}
variable "alb_private_solutionsnplusone" {}
variable "alb_tg" {}

# Rol de IAM para la función Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

#Creo la política y la asigno al rol
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-policy"
  description = "Policy for Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:AttachNetworkInterface"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}

# Grupo de seguridad para la función Lambda
resource "aws_security_group" "lambda_sg" {
  name_prefix = "lambda-sg"
  vpc_id = var.public_vpc_solutionsnplusone.id
  # Regla para permitir tráfico solo desde el NLB en el puerto 80
  ingress {
    description = "Permitir trafico desde el Network Load Balancer [ALB] en el puerto 80"
    from_port   = 80
    to_port     = 80
    protocol    = "http"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

# Recurso de la función Lambda
resource "aws_lambda_function" "lambda_function" {
  function_name = "handler-keys-${var.layer}-${var.stage_name}"
  s3_bucket = "${var.layer}-apis-lambda-${var.stage_name}"
  s3_key    = "${var.layer}-handler-keys.zip"
  role          = aws_iam_role.lambda_role.arn
  handler       = "dist.lambdaHandler"
  runtime       = "nodejs16.x"
  timeout       = 900
  memory_size   = 256

  vpc_config {
    subnet_ids = [var.solutionsnplusone_subnets[2].id,var.solutionsnplusone_subnets[3].id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

output "lambda_function" {
  value = aws_lambda_function.lambda_function
}

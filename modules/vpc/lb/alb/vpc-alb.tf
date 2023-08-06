variable "public_vpc_solutionsnplusone" {}
variable "subnets_solutionsnplusone" {}
variable "stage_name" {}
variable "layer" {}
variable "nlb" {}

#Creo el ALB para la subnet Privada
resource "aws_lb" "alb_private_solutionsnplusone" {
  name               = "albpr-${var.layer}-${var.stage_name}"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.subnets_solutionsnplusone[2].id,var.subnets_solutionsnplusone[3].id]

  tags = {
    Name = "Private ALB ${var.layer}-${var.stage_name}"
  }
}

# Target Group para el ALB
resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-tg-${var.layer}-${var.stage_name}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.public_vpc_solutionsnplusone.id
  target_type = "lambda"
}

# Crear el listener para el ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb_private_solutionsnplusone.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Unauthorized"
      status_code  = "401"
    }
  }
}

output "alb_private_solutionsnplusone" {
  value = aws_lb.alb_private_solutionsnplusone
}

output "alb_tg" {
  value = aws_lb_target_group.alb_tg
}


/*# Regla para redirigir las solicitudes /keys/* a la función Lambda
resource "aws_lb_listener_rule" "alb_listener_rule_keys" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 10

  action {
    type             = "lambda"
    lambda_target_group_arn = aws_lb_target_group.nlb_tg.arn
  }

  condition {
    path_pattern {
      values = ["/keys/*"]
    }
  }
}

# Regla para responder con 401 para cualquier otra ruta
resource "aws_lb_listener_rule" "alb_listener_rule_401" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 20

  action {
    type = "fixed-response"
    content_type = "text/plain"
    message_body = "Unauthorized"
    status_code  = "401"
  }
}*/

variable "public_vpc_solutionsnplusone" {}
variable "igw_solutionsnplusone" {}
variable "subnets_solutionsnplusone" {}
variable "stage_name" {}
variable "layer" {}

#Creo el NLB
resource "aws_lb" "nlb" {
  name               = "nlb-${var.layer}-${var.stage_name}"
  internal           = false
  load_balancer_type = "network"
  subnets            = [
    var.subnets_solutionsnplusone[0].id,
    var.subnets_solutionsnplusone[1].id,
    var.subnets_solutionsnplusone[2].id,
    var.subnets_solutionsnplusone[3].id
  ]

  tags = {
    Name = "NLB ${var.layer}-${var.stage_name}"
  }
}

# Creo el Security Group para el NLB y permito el tráfico desde Internet
resource "aws_security_group" "nlb_sg" {
  name_prefix = "nlb-sg"

  ingress {
    description = "Todo el trafico se redirige hacia el NLB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NLB Grupo de Seguridad"
  }
}

# Permitir que el NLB reciba tráfico desde el Internet Gateway
resource "aws_security_group_rule" "allow_inbound_igw_to_nlb" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  # Aquí puedes restringir el rango de direcciones IP si es necesario
  security_group_id = aws_security_group.nlb_sg.id
}


# Creo el Target Group para el NLB
resource "aws_lb_target_group" "nlb_tg" {
  name        = "nlb-tg-${var.layer}-${var.stage_name}"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.public_vpc_solutionsnplusone.id
  target_type = "ip"

  # Opcional: Puedes ajustar las opciones de health check según tus necesidades
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200-299"
  }
}

# Creo el Listener del NLB que redirige el tráfico hacia el Target Group
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb_tg.arn
    type             = "forward"
  }
}

output "nlb_sg" {
  value = aws_security_group.nlb_sg
}

output "nlb" {
  value = aws_lb.nlb
}

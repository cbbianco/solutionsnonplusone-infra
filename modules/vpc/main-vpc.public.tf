variable "stage_name" {}
variable "cidr" {}
variable "layer" {}
variable "subnet_cidrs" {}
variable "availability_zones" {}
variable "subnet_cidrs_public" {}

#Creo la VPC Pública
resource "aws_vpc" "solutionsnplusone_vpc" {
  cidr_block = var.cidr

  tags = {
    Name = "${var.layer}-${var.stage_name}"
  }
}

# Creo las subnets de la VPC Pública
resource "aws_subnet" "solutionsnplusone_subnets" {
  count = length(var.subnet_cidrs)

  vpc_id                  = aws_vpc.solutionsnplusone_vpc.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.layer}-${var.stage_name}-${count.index}"
  }
}

#Creo el Internet Gateway
module "igw_solutionsnplusone" {
  source = "./igw"
  public_vpc_solutionsnplusone = aws_vpc.solutionsnplusone_vpc
  public_subnet_solutionsnplusone = aws_subnet.solutionsnplusone_subnets
  subnet_cidrs_public = var.subnet_cidrs_public
}

#Creo los NLB de la VPC y la ruta para el trafico de la misma.
module "nlb_solutionsnplusone" {
  source = "./lb/nlb"
  public_vpc_solutionsnplusone = aws_vpc.solutionsnplusone_vpc
  subnets_solutionsnplusone = aws_subnet.solutionsnplusone_subnets
  stage_name = var.stage_name
  layer = var.layer
  igw_solutionsnplusone = module.igw_solutionsnplusone
}

#Creo los ALB de las Subnets
module "alb_solutionsnplusone" {
  source = "./lb/alb"
  public_vpc_solutionsnplusone = aws_vpc.solutionsnplusone_vpc
  subnets_solutionsnplusone = aws_subnet.solutionsnplusone_subnets
  stage_name = var.stage_name
  layer = var.layer
  nlb = module.nlb_solutionsnplusone.nlb
}

output "public_vpc_solutionsnplusone" {
  value = aws_vpc.solutionsnplusone_vpc
}

output "alb_private_solutionsnplusone" {
  value = module.alb_solutionsnplusone.alb_private_solutionsnplusone
}


output "solutionsnplusone_subnets" {
  value = aws_subnet.solutionsnplusone_subnets
}

output "alb_tg" {
  value = module.alb_solutionsnplusone.alb_tg
}

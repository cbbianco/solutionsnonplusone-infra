#VPC, SUBNET, LB
module "vpc_solutionsnplusone" {
    source = "./modules/vpc"
    stage_name = var.stage_name
    cidr = var.cidr
    layer = var.layer
    subnet_cidrs = var.subnet_cidrs
    availability_zones = var.availability_zones
    subnet_cidrs_public = var.subnet_cidrs_public
}

#Lambda
module "lambda_solutionsnplusone" {
    source = "./modules/lambda/keys"
    layer = var.layer
    stage_name = var.stage_name
    public_vpc_solutionsnplusone = module.vpc_solutionsnplusone.public_vpc_solutionsnplusone
    alb_private_solutionsnplusone= module.vpc_solutionsnplusone.alb_private_solutionsnplusone
    solutionsnplusone_subnets = module.vpc_solutionsnplusone.solutionsnplusone_subnets
    alb_tg = module.vpc_solutionsnplusone.alb_tg
}

#Api Gateway
module "apigateway_keys_solutionsplusone" {
    source = "./modules/apigateway"
    layer = var.layer
    stage_name = var.stage_name
    domain_keys = var.domain_keys
    lambda = module.lambda_solutionsnplusone.lambda_function
    alb_private_solutionsnplusone = module.vpc_solutionsnplusone.alb_private_solutionsnplusone
}

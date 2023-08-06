layer               = "solutionsnplusone"
stage_name          = "dev"
cidr                = "10.0.0.0/16"
subnet_cidrs        = ["10.0.1.0/24", "10.0.2.0/24","10.0.3.0/24","10.0.4.0/24"]
subnet_cidrs_public        = ["10.0.3.0/24","10.0.4.0/24"]
availability_zones  = ["us-east-1a", "us-east-1b","us-east-1c","us-east-1d"]
bucket_lambdas              = "lambdas"
domain_keys              = "keys"

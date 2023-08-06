variable "stage_name" { 
    description = "stage del ambiente"
    type = string
}

variable "layer" { 
    description = "nombre del proyecto"
    type = string
}

variable "domain_keys" {
  description = "dominio del proyecto"
  type = string
}

variable "bucket_lambdas" { 
    description = "bucket de las lambdas"
    type = string
}

variable "cidr" { 
    description = "representación máxima de ip's posible que puede ingresar en la vpc"
    type = string
}

variable "subnet_cidrs" {
  type    = list(string)
}

variable "subnet_cidrs_public" {
  type    = list(string)
}

variable "availability_zones" {
  type    = list(string)
}

variable "public_vpc_solutionsnplusone" {}
variable "public_subnet_solutionsnplusone" {}
variable "subnet_cidrs_public" {}

# Creo el Internet Gateway 
resource "aws_internet_gateway" "igw_solutionsnplusone" {
  vpc_id = var.public_vpc_solutionsnplusone.id
  tags = {
    Name = "Internet Gateway"
  }
}

# Crear la tabla de enrutamiento para las subnets públicas
resource "aws_route_table" "public_route_table" {
  vpc_id = var.public_vpc_solutionsnplusone.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_solutionsnplusone.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Asociar las subnets públicas a la tabla de enrutamiento
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.subnet_cidrs_public)
  subnet_id      = element(var.public_subnet_solutionsnplusone.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

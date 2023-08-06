variable "stage_name" {}
variable "layer" {}
variable "domain_keys" {}
variable "lambda" {}
variable "alb_private_solutionsnplusone" {}

# Recurso de API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "api-${var.layer}-${var.stage_name}-${var.domain_keys}"
}

# Crea un recurso de recurso raíz en el API Gateway
resource "aws_api_gateway_resource" "root_keys" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "keys"
}

# Crea un recurso "api" bajo el recurso raíz
resource "aws_api_gateway_resource" "keys_api" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.root_keys.id
  path_part   = "api"
}

# Crea un recurso "v1" bajo el recurso "api"
resource "aws_api_gateway_resource" "api_v1" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.keys_api.id
  path_part   = "v1"
}

# Crea un recurso "handler" bajo el recurso "v1"
resource "aws_api_gateway_resource" "api_handler" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.api_v1.id
  path_part   = "handler"
}

/*# Crea un recurso "keys" bajo el recurso "handler"
resource "aws_api_gateway_resource" "handler_keys" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.api_handler.id
  path_part   = "keys"
}

# Crea el método GET para el recurso "keys"
resource "aws_api_gateway_method" "endpoint_keys" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.handler_keys.id
  http_method   = "GET"
  authorization = "NONE" # Puedes ajustar esto según tus necesidades de autorización
}

# Crea el método OPTIONS para el recurso "keys"
resource "aws_api_gateway_method" "options_keys" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.handler_keys.id
  http_method   = "OPTIONS"
  authorization = "NONE" # Puedes ajustar esto según tus necesidades de autorización
}

# Crea la integración HTTP entre el método API Gateway y el ALB
resource "aws_api_gateway_integration" "keys_endpoint_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.handler_keys.id
  http_method             = aws_api_gateway_method.endpoint_keys.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.alb_private_solutionsnplusone.dns_name}"
}

/*# Crea una respuesta de integración para el método
resource "aws_api_gateway_integration_response" "integracion_response_keys" {
  rest_api_id      = aws_api_gateway_rest_api.api_gateway.id
  resource_id      = aws_api_gateway_resource.handler_keys.id
  http_method      = aws_api_gateway_method.endpoint_keys.http_method
  status_code      = "200"
  response_templates = {
    "application/json" = ""
  }
}

# Crea una respuesta de integración para el método OPTIONS
resource "aws_api_gateway_integration_response" "integracion_response_options_keys" {
  rest_api_id      = aws_api_gateway_rest_api.api_gateway.id
  resource_id      = aws_api_gateway_resource.handler_keys.id
  http_method      = aws_api_gateway_method.options_keys.http_method
  status_code      = "200"
  response_templates = {
    "application/json" = ""
  }
}

# Crea una respuesta para el método
resource "aws_api_gateway_method_response" "example_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.handler_keys.id
  http_method = aws_api_gateway_method.endpoint_keys.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

# Crea una respuesta para el método OPTIONS
resource "aws_api_gateway_method_response" "example_method_response_options" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.handler_keys.id
  http_method = aws_api_gateway_method.options_keys.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}*/

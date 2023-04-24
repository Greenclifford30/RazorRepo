locals {
  api_name = "razorshop-api"
}

resource "aws_api_gateway_rest_api" "barbershop_api" {
  name        = local.api_name
  description = "Barbershop REST API"
}

resource "aws_api_gateway_deployment" "barbershop_deployment" {
  rest_api_id = aws_api_gateway_rest_api.barbershop_api.id
  stage_name  = "v1"
}


resource "aws_api_gateway_resource" "services_resource" {
  rest_api_id = aws_api_gateway_rest_api.barbershop_api.id
  parent_id   = aws_api_gateway_rest_api.barbershop_api.root_resource_id
  path_part   = "services"
}

resource "aws_api_gateway_method" "services_method" {
  rest_api_id   = aws_api_gateway_rest_api.barbershop_api.id
  resource_id   = aws_api_gateway_resource.services_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "services_mock_integration" {
  rest_api_id = aws_api_gateway_rest_api.barbershop_api.id
  resource_id = aws_api_gateway_resource.services_resource.id
  http_method = aws_api_gateway_method.services_method.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_integration_response" "services_mock_response" {
  rest_api_id = aws_api_gateway_rest_api.barbershop_api.id
  resource_id = aws_api_gateway_resource.services_resource.id
  http_method = aws_api_gateway_method.services_method.http_method
  status_code = "200"

  response_templates = {
    "application/json" = jsonencode({
      status = "success",
      data = [
        {
          id          = 1,
          name        = "Haircut",
          description = "Basic haircut",
          duration    = 30,
          price       = 25
        },
        {
          id          = 2,
          name        = "Haircut & Shave",
          description = "Haircut and shave",
          duration    = 60,
          price       = 40
        }
      ]
    })
  }
}

resource "aws_api_gateway_method_response" "services_mock_method_response" {
  rest_api_id = aws_api_gateway_rest_api.barbershop_api.id
  resource_id = aws_api_gateway_resource.services_resource.id
  http_method = aws_api_gateway_method.services_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}
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
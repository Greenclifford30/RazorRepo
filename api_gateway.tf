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
  rest_api_id = aws_apigateway_rest_api.barbershop_api.id
  resource_id = aws_api_gateway_resource.services_resource.id
  http_method = "GET"

  authorization = "NONE" # Or use "AWS_IAM" if you want to require authentication

  request_parameters = {
    "method.request.header.Authorization" = true
  }

  request_models = {
    "application/json" = "Empty"
  }

  integration {
    type                   = "MOCK"
    passthrough_behavior   = "WHEN_NO_MATCH"
    http_method            = "POST"
    request_templates      = {
      "application/json" = jsonencode({
        statusCode = "200"
      })
    }
    integration_responses  = [aws_api_gateway_integration_response.services_mock_response]
  }

  method_responses      = [aws_api_gateway_method_response.services_mock_method_response]
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


# Create a method for the POST /api/bookings endpoint
resource "aws_api_gateway_method" "bookings" {
  rest_api_id = aws_apigateway_rest_api.barbershop_api.id
  resource_id = aws_api_gateway_resource.bookings.id
  http_method = "POST"

  authorization = "NONE" # Or use "AWS_IAM" if you want to require authentication

  request_parameters = {
    "method.request.header.Authorization" = true
  }

  request_models = {
    "application/json" = "Empty"
  }

  request_validator_id = aws_api_gateway_request_validator.bookings.id

integration {
    type                   = "MOCK"
    passthrough_behavior   = "WHEN_NO_MATCH"
    http_method            = "POST"
    request_templates      = {
      "application/json" = jsonencode({
        statusCode = "200"
      })
    }
    integration_responses  = [
      {
        status_code = "200"
        response_templates = {
          "application/json" = jsonencode({
    "status": "success",
    "message": "Booking created successfully.",
    "data": {
        "id": 1,
        "user_id": 1,
        "service_id": 1,
        "start_time": "2023-04-24T10:00:00Z",
        "end_time": "2023-04-24T10:30:00Z",
        "status": "scheduled",
        "created_at": "2023-04-23T12:00:00Z",
        "updated_at": "2023-04-23T12:00:00Z"
    }
}

)
        }
      },
      {
        selection_pattern = "4\\d{2}"
        status_code       = "400"
        response_templates = {
          "application/json" = jsonencode({
            status = "error"
            message = "Bad request"
          })
        }
      }
    ]
  }

  method_responses = [
    {
      status_code       = "200"
      response_models = {
        "application/json" = "Empty"
      }
    },
    {
      status_code       = "400"
      response_models = {
        "application/json" = "Empty"
      }
    }
  ]
}

# Create a resource for the /api/bookings endpoint
resource "aws_api_gateway_resource" "bookings" {
  rest_api_id = aws_apigateway_rest_api.barbershop_api.id
  parent_id   = aws_apigateway_rest_api.barbershop_api.root_resource_id
  path_part   = "bookings"
}

# Create a request validator for the POST /api/bookings endpoint
resource "aws_api_gateway_request_validator" "bookings" {
  rest_api_id = aws_apigateway_rest_api.bookings.id
  name        = "bookings-request-validator"
  validate_request_body = true
}



resource "aws_api_gateway_method" "payments" {
  rest_api_id = aws_apigateway_rest_api.barbershop_api.id
  resource_id = aws_api_gateway_resource.payments.id
  http_method = "POST"

  authorization = "NONE" # Or use "AWS_IAM" if you want to require authentication

  request_parameters = {
    "method.request.header.Authorization" = true
  }

  request_models = {
    "application/json" = "Empty"
  }

  integration {
    type                   = "MOCK"
    passthrough_behavior   = "WHEN_NO_MATCH"
    http_method            = "POST"
    request_templates      = {
      "application/json" = jsonencode({
        statusCode = "200"
      })
    }
    integration_responses  = [
      {
        status_code = "200"
        response_templates = {
          "application/json" = jsonencode({
            status = "success"
            message = "Payment processed successfully."
            data = {
              id = 1
              booking_id = 1
              user_id = 1
              payment_amount = 25
              tip_amount = 5
              payment_status = "completed"
              payment_method = "stripe"
            }
          })
        }
      },
      {
        selection_pattern = "4\\d{2}"
        status_code       = "400"
        response_templates = {
          "application/json" = jsonencode({
            status = "error"
            message = "Bad request"
          })
        }
      }
    ]
  }

  method_responses = [
    {
      status_code       = "200"
      response_models = {
        "application/json" = "Empty"
      }
    },
    {
      status_code       = "400"
      response_models = {
        "application/json" = "Empty"
      }
    }
  ]
}

# Create a resource for the /api/payments endpoint
resource "aws_api_gateway_resource" "payments" {
  rest_api_id = aws_apigateway_rest_api.barbershop_api.id
  parent_id   = aws_apigateway_rest_api.barbershop_api.root_resource_id
  path_part   = "payments"
}
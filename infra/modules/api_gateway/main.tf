resource "aws_api_gateway_rest_api" "backend_api" {
  name        = "API Gateway for Lambda Backend"
  description = "API Gateway"
  tags = {
    Name        = "Backend API Gateway"
    Environment = "Production"
  }
}

resource "aws_api_gateway_resource" "backend_path_resource" {
  rest_api_id = aws_api_gateway_rest_api.backend_api.id
  parent_id   = aws_api_gateway_rest_api.backend_api.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "backend_method" {
  rest_api_id   = aws_api_gateway_rest_api.backend_api.id
  resource_id   = aws_api_gateway_resource.backend_path_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_backend_integration" {
  rest_api_id             = aws_api_gateway_rest_api.backend_api.id
  resource_id             = aws_api_gateway_resource.backend_path_resource.id
  http_method             = aws_api_gateway_method.backend_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_lambda_permission" "backend_api_permissions" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.backend_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.backend_api.id
  stage_name  = "prod"
  depends_on = [
    aws_api_gateway_integration.lambda_backend_integration
  ]
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = aws_api_gateway_deployment.api_gateway_deployment.invoke_url
}

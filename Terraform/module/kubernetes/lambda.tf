data "aws_caller_identity" "current" {}

data "aws_api_gateway_rest_api" "fastfoodapi_api" {
  name = "fastfoodapi-api"
}

data "aws_api_gateway_resource" "fastfoodapi_resource" {
  rest_api_id = data.aws_api_gateway_rest_api.fastfoodapi_api.id
  path        = "/fastfoodapi"
}

resource "null_resource" "download_lambda_zip" {
  provisioner "local-exec" {
    command = "curl -L -o ${path.module}/lambda_function.zip https://github.com/LeonardoComar/fast-food-fase-3-terraform-lambda/releases/download/latest/lambda_function.zip"
  }
}

resource "aws_lambda_function" "fastfoodapi_lambda" {
  filename      = "${path.module}/lambda_function.zip"
  function_name = "CPFValidation"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = data.aws_iam_role.fastfood_role.arn
  timeout       = 30

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.security_group_id]
  }

  environment {
    variables = {
      USER_POOLID = data.aws_cognito_user_pool.fastfood_user_pool.id
      API_URL     = "http://${kubernetes_service.fastfoodapi_service.status[0].load_balancer[0].ingress[0].hostname}/api/Clientes/filtrar"
    }
  }

  depends_on = [null_resource.download_lambda_zip]
}

resource "aws_lambda_permission" "allow_apigateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fastfoodapi_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${data.aws_api_gateway_rest_api.fastfoodapi_api.id}/*"
}

resource "aws_api_gateway_integration" "fastfoodapi_lambda_integration" {
  rest_api_id             = data.aws_api_gateway_rest_api.fastfoodapi_api.id
  resource_id             = data.aws_api_gateway_resource.fastfoodapi_resource.id
  http_method             = "ANY"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.fastfoodapi_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "fastfoodapi_deployment" {
  rest_api_id = data.aws_api_gateway_rest_api.fastfoodapi_api.id

  depends_on = [
    aws_api_gateway_integration.fastfoodapi_lambda_integration
  ]
}

resource "aws_api_gateway_stage" "fastfoodapi_stage" {
  rest_api_id   = data.aws_api_gateway_rest_api.fastfoodapi_api.id
  stage_name    = "prod"
  deployment_id = aws_api_gateway_deployment.fastfoodapi_deployment.id
}
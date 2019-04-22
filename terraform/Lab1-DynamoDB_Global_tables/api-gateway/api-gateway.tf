# API Gateway

provider "aws" {
  alias  = "region"
  region = "${var.region_provider}"
}

resource "aws_api_gateway_rest_api" "api-lambda-dynamodb" {
  provider    = "aws.region"
  name        = "lambda-dynamodb"
  description = "Lambda functions for accessing DynamoDB global"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "users" {
  provider    = "aws.region"
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  parent_id   = "${aws_api_gateway_rest_api.api-lambda-dynamodb.root_resource_id}"
  path_part   = "users"
}

resource "aws_api_gateway_method" "users" {
  provider      = "aws.region"
  rest_api_id   = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id   = "${aws_api_gateway_resource.users.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  provider    = "aws.region"
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id = "${aws_api_gateway_method.users.resource_id}"
  http_method = "${aws_api_gateway_method.users.http_method}"

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "${var.lambda_filler_invoke}"
}

resource "aws_api_gateway_deployment" "lambda" {
  provider    = "aws.region"
  depends_on  = ["aws_api_gateway_integration.lambda"]
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  stage_name  = "testing"
}

resource "aws_lambda_permission" "apigw" {
  provider      = "aws.region"
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.lambda.execution_arn}"
}

resource "aws_api_gateway_method_response" "200" {
  provider    = "aws.region"
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id = "${aws_api_gateway_resource.users.id}"
  http_method = "${aws_api_gateway_method.users.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "IntegrationResponse" {
  provider    = "aws.region"
  depends_on  = ["aws_api_gateway_integration.lambda"]
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id = "${aws_api_gateway_resource.users.id}"
  http_method = "${aws_api_gateway_method.users.http_method}"
  status_code = "${aws_api_gateway_method_response.200.status_code}"
}

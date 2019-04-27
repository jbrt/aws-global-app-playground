# API Gateway
# - Creation of one API
# - Add a resource called users
# - Witout 2 methods GET/POST
# - 2 integration with Lambda functions
# - 2 integration response
# - Deploy the whole API

provider "aws" {
  alias  = "region"
  region = "${var.region_provider}"
}

#################
# API Declaration
#################

resource "aws_api_gateway_rest_api" "api-lambda-dynamodb" {
  provider    = "aws.region"
  name        = "lambda-dynamodb"
  description = "Lambda functions for accessing DynamoDB global"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#####################################
# We create a resource called 'users'
#####################################

resource "aws_api_gateway_resource" "users" {
  provider    = "aws.region"
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  parent_id   = "${aws_api_gateway_rest_api.api-lambda-dynamodb.root_resource_id}"
  path_part   = "users"
}

###################################################
# Declaration of two methods for 'users' GET & POST
###################################################

resource "aws_api_gateway_method" "users_post" {
  provider      = "aws.region"
  rest_api_id   = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id   = "${aws_api_gateway_resource.users.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "users_get" {
  provider      = "aws.region"
  rest_api_id   = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id   = "${aws_api_gateway_resource.users.id}"
  http_method   = "GET"
  authorization = "NONE"
}

####################
# Lambda integration 
####################

resource "aws_api_gateway_integration" "lambda_filler" {
  provider    = "aws.region"
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id = "${aws_api_gateway_method.users_post.resource_id}"
  http_method = "${aws_api_gateway_method.users_post.http_method}"

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "${var.lambda_filler_invoke}"
}

resource "aws_api_gateway_integration" "lambda_getter" {
  provider    = "aws.region"
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id = "${aws_api_gateway_method.users_get.resource_id}"
  http_method = "${aws_api_gateway_method.users_get.http_method}"

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "${var.lambda_getter_invoke}"
}

#######################################################
# Adding permission for API Gateway to Lambda functions
#######################################################

resource "aws_lambda_permission" "apigw_filler" {
  provider      = "aws.region"
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_filler_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api-lambda-dynamodb.execution_arn}*/*/*"
}

resource "aws_lambda_permission" "apigw_getter" {
  provider      = "aws.region"
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_getter_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api-lambda-dynamodb.execution_arn}*/*/*"
}

##########################################
# Methods responses & integration response
##########################################

# POST/Filler
resource "aws_api_gateway_method_response" "200_filler" {
  provider    = "aws.region"
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id = "${aws_api_gateway_resource.users.id}"
  http_method = "${aws_api_gateway_method.users_post.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "IntegrationResponseFiller" {
  provider    = "aws.region"
  depends_on  = ["aws_api_gateway_integration.lambda_filler"]
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id = "${aws_api_gateway_resource.users.id}"
  http_method = "${aws_api_gateway_method.users_post.http_method}"
  status_code = "${aws_api_gateway_method_response.200_filler.status_code}"
}

# GET/Getter
resource "aws_api_gateway_method_response" "200_getter" {
  provider    = "aws.region"
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id = "${aws_api_gateway_resource.users.id}"
  http_method = "${aws_api_gateway_method.users_get.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "IntegrationResponseGetter" {
  provider    = "aws.region"
  depends_on  = ["aws_api_gateway_integration.lambda_getter"]
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  resource_id = "${aws_api_gateway_resource.users.id}"
  http_method = "${aws_api_gateway_method.users_get.http_method}"
  status_code = "${aws_api_gateway_method_response.200_getter.status_code}"
}

########################
# Deployment of this API
########################

resource "aws_api_gateway_deployment" "lambda" {
  provider    = "aws.region"
  depends_on  = ["aws_api_gateway_integration.lambda_filler", "aws_api_gateway_integration.lambda_getter"]
  rest_api_id = "${aws_api_gateway_rest_api.api-lambda-dynamodb.id}"
  stage_name  = "testing"
}

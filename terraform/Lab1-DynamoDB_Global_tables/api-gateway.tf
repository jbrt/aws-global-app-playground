# API Gateway

resource "aws_api_gateway_rest_api" "lambda-elb-test-lambda" {
  provider    = "aws.primary"
  name        = "lambda-elb-test"
  description = "Lambda vs Elastic Beanstalk Lambda Example"
}

resource "aws_api_gateway_resource" "question" {
  provider    = "aws.primary"
  rest_api_id = "${aws_api_gateway_rest_api.lambda-elb-test-lambda.id}"
  parent_id   = "${aws_api_gateway_rest_api.lambda-elb-test-lambda.root_resource_id}"
  path_part   = "question"
}

resource "aws_api_gateway_method" "question" {
  provider      = "aws.primary"
  rest_api_id   = "${aws_api_gateway_rest_api.lambda-elb-test-lambda.id}"
  resource_id   = "${aws_api_gateway_resource.question.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  provider    = "aws.primary"
  rest_api_id = "${aws_api_gateway_rest_api.lambda-elb-test-lambda.id}"
  resource_id = "${aws_api_gateway_method.question.resource_id}"
  http_method = "${aws_api_gateway_method.question.http_method}"

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "${aws_lambda_function.dynamodb_filler.invoke_arn}"
}

resource "aws_api_gateway_deployment" "lambda" {
  provider = "aws.primary"

  depends_on = [
    "aws_api_gateway_integration.lambda",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.lambda-elb-test-lambda.id}"
  stage_name  = "test"
}

resource "aws_lambda_permission" "apigw" {
  provider      = "aws.primary"
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.dynamodb_getter.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_deployment.lambda.execution_arn}/*/*"
}

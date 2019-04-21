# Creating Lambda functions

provider "aws" {
  alias  = "region"
  region = "${var.region_provider}"
}

resource "random_string" "postfix" {
  length = 4
  special = false
}

# Role IAM & Polices for the Lambda functions
resource "aws_iam_role" "iam_role_lambda" {
  provider = "aws.region"
  name     = "LambdaRoleForLab-${random_string.postfix.result}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  provider    = "aws.region"
  name        = "Lab1_lambda_logging-${random_string.postfix.result}"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "dynamodb_permissions" {
  provider    = "aws.region"
  name        = "Lab1_dynamodb_permissions-${random_string.postfix.result}"
  description = "Lab1 GetItem and Scan for DynamoDB"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1555779874387",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:Scan"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  provider   = "aws.region"
  role       = "${aws_iam_role.iam_role_lambda.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  provider   = "aws.region"
  role       = "${aws_iam_role.iam_role_lambda.name}"
  policy_arn = "${aws_iam_policy.dynamodb_permissions.arn}"
}

# Lambda functions 

data "archive_file" "filler" {
  type        = "zip"
  source_dir  = "../../lambda/dynamodb_filler"
  output_path = "filler.zip"
}

data "archive_file" "getter" {
  type        = "zip"
  source_dir  = "../../lambda/dynamodb_getter"
  output_path = "getter.zip"
}

resource "aws_lambda_function" "dynamodb_filler" {
  provider         = "aws.region"
  filename         = "filler.zip"
  source_code_hash = "${data.archive_file.filler.output_base64sha256}"
  function_name    = "DynamoDB_Filler"
  role             = "${aws_iam_role.iam_role_lambda.arn}"
  description      = "Put items into a DynamoDB table"
  handler          = "dynamodb_filler.lambda_handler"
  runtime          = "python3.7"
  timeout          = 10

  environment {
    variables = {
      TABLE_NAME = "global-table"
    }
  }
}

resource "aws_lambda_function" "dynamodb_getter" {
  provider         = "aws.region"
  filename         = "getter.zip"
  source_code_hash = "${data.archive_file.getter.output_base64sha256}"
  function_name    = "DynamoDB_Getter"
  role             = "${aws_iam_role.iam_role_lambda.arn}"
  description      = "Scan items from a DynamoDB table"
  handler          = "dynamodb_getter.lambda_handler"
  runtime          = "python3.7"
  timeout          = 10

  environment {
    variables = {
      TABLE_NAME = "global-table"
      SECONDS    = 10
    }
  }
}

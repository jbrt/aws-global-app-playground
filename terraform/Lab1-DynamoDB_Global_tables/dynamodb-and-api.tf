# Deploy DynamoDB global table + Rest API

# Deploy a DynamoDB table
module "dynamodb-global-table" {
  source         = "../modules/global-table-dynamodb"
  first_region   = "eu-west-1"
  second_region  = "us-east-1"
  global_table   = "global-table"
  hash_key       = "id"
  read_capacity  = 1
  write_capacity = 1
  tags           = "${local.tags}"

  table_schema = [
    {
      name = "id"
      type = "N"
    },
  ]
}

# Deploy Lambda functions on each regions
module "lambda-functions_region1" {
  source          = "./lambda"
  region_provider = "${var.first_region}"
}

module "lambda-functions_region2" {
  source          = "./lambda"
  region_provider = "${var.second_region}"
}

# Deploy API Gateway on each region
module "api-gateway_region1" {
  source               = "./api-gateway"
  lambda_filler_name   = "${module.lambda-functions_region1.filler_name}"
  lambda_filler_invoke = "${module.lambda-functions_region1.filler_invoke_arn}"
  lambda_getter_name   = "${module.lambda-functions_region1.getter_name}"
  lambda_getter_invoke = "${module.lambda-functions_region1.getter_invoke_arn}"
  region_provider      = "${var.first_region}"
}

module "api-gateway_region2" {
  source               = "./api-gateway"
  lambda_filler_name   = "${module.lambda-functions_region2.filler_name}"
  lambda_filler_invoke = "${module.lambda-functions_region2.filler_invoke_arn}"
  lambda_getter_name   = "${module.lambda-functions_region1.getter_name}"
  lambda_getter_invoke = "${module.lambda-functions_region1.getter_invoke_arn}"
  region_provider      = "${var.second_region}"
}

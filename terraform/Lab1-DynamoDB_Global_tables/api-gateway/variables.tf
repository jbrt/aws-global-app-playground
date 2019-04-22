# Input variables

variable "region_provider" {
  description = "Name of the provier to use for the creation of resources"
}

variable "lambda_name" {
  description = "Name of the filler Lambda function"
}

variable "lambda_filler_invoke" {
  description = "Invoke ARN of the filler Lambda function"
}
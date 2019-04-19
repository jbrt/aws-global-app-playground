variable "first_region" {
  description = "Name of the first AWS region"
  default     = "eu-west-1"
}

variable "second_region" {
  description = "Name of the second AWS region"
  default     = "us-east-1"
}

#####################
# Providers variables 
#####################

# AWS Providers

provider "aws" {
  alias  = "primary"
  region = "${var.first_region}"
}

provider "aws" {
  alias  = "secondary"
  region = "${var.second_region}"
}

####################
# DynamoDB variables
####################

variable "global_table" {
  description = "Name of the Global DynamoDB table"
  default     = "global-table"
}

variable "table_schema" {
  description = "A list of attributes that describe the schema table"
  type        = "list"
}

variable "read_capacity" {
  description = "Read capacity for tables"
  type        = "number"
}

variable "write_capacity" {
  description = "Write capacity for tables"
  type        = "number"
}

#####################
# Tags
#####################

variable "tags" {
  description = "Dictionary of tags"
  type        = "map"
  default     = {}
}
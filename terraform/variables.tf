# Region variables 

variable "first-region" {
  description = "Name of the first AWS region"
  default     = "eu-west-1"
}

variable "second-region" {
  description = "Name of the second AWS region"
  default     = "us-east-1"
}

/*

variable "project_name" {
  description = "General identifier for created resources"
  default     = "global-playground"
}

###############
# VPC variables
###############

variable "first_cidr" {
  description = "CIDR on the first region"
  default     = "10.1.0.0/16"
}

variable "first_azs" {
  description = "List of AZs to use on the first region"
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "first_public_subnets" {
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "first_private_subnets" {
  default = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
}

variable "first_database_subnets" {
  default = ["10.1.7.0/24", "10.1.8.0/24", "10.1.9.0/24"]
}

variable "second_cidr" {
  description = "CIDR on the second region"
  default     = "10.2.0.0/16"
}

variable "second_azs" {
  description = "List of AZs to use on the second region"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "second_public_subnets" {
  default = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
}

variable "second_private_subnets" {
  default = ["10.2.4.0/24", "10.2.5.0/24", "10.2.6.0/24"]
}

variable "second_database_subnets" {
  default = ["10.2.7.0/24", "10.2.8.0/24", "10.2.9.0/24"]
}

####################
# DynamoDB variables
####################

variable "global_table" {
  description = "Name of the Global DynamoDB table"
  default     = "global-table"
}

##################
# Aurora Global DB
##################

variable "db_instance" {
  description = "For global DB instance on db.r3 and db.r4 are allowed"
  default     = "db.r3.large"
}

variable "db_username" {
  description = "Default DB username"
  default     = "dbadmin"
}

variable "db_name" {
  description = "Name of the Global DB"
  default     = "globaldb"
}

################
# S3 Buckets
################

variable "s3_first_bucket" {
  description = "Name of the bucket on the first region"
  default     = "global-playground-first-region"
}

variable "s3_second_bucket" {
  description = "Name of the bucket on the second region"
  default     = "global-playground-second-region"
}

#####################
# Tags
#####################

locals {
  tags = {
    Project   = "Global App PlayGround"
    Terraform = true
  }
}
*/
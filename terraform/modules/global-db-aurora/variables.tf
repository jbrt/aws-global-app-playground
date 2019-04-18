##################
# Region variables 
##################

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

##################
# VPC variables
##################
variable "first_db_subnets" {
  description = "List of DB subnets on the first region"
  type        = "list"
}

variable "second_db_subnets" {
  description = "List of DB subnets on the first region"
  type        = "list"
}

variable "first_azs" {
  description = "List of AZs to use on the first region"
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "second_azs" {
  description = "List of AZs to use on the second region"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
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

#####################
# Tags
#####################

variable "tags" {
  description = "Dictionary of tags"
  type        = "map"
  default     = {}
}

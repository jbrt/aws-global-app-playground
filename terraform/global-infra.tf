# Create a Global VPC structure
# By default, all goes into eu-west-1 & us-east-1

module "global-vpc" {
  source        = "./modules/global-vpc"
  project_name  = "global-playground"
  first_region  = "eu-west-1"
  second_region = "us-east-1"
  first_azs     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  second_azs    = ["us-east-1a", "us-east-1b", "us-east-1c"]
  project_name  = "global-playground"
  tags          = "${local.tags}"
}

module "buckets-replicated" {
  source           = "./modules/global-s3-buckets"
  first_region     = "eu-west-1"
  second_region    = "us-east-1"
  s3_first_bucket  = "global-playground-first-region"
  s3_second_bucket = "global-playground-second-region"
  tags             = "${local.tags}"
}

module "dynamodb-global-table" {
  source         = "./modules/global-table-dynamodb"
  first_region   = "eu-west-1"
  second_region  = "us-east-1"
  global_table   = "global-table"
  read_capacity  = 1
  write_capacity = 1
  tags           = "${local.tags}"

  table_schema = [
    {
      name = "myAttribute"
      type = "S"
    },
  ]
}

module "aurora-globalDB" {
  source            = "./modules/global-db-aurora"
  first_region      = "eu-west-1"
  second_region     = "us-east-1"
  first_azs         = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  second_azs        = ["us-east-1a", "us-east-1b", "us-east-1c"]
  first_db_subnets  = "${module.global-vpc.first_db_subnets}"
  second_db_subnets = "${module.global-vpc.second_db_subnets}"
  db_username       = "dbadmin"
  db_name           = "globaldb"
}

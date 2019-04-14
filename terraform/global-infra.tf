# Create a Global VPC structure
# By default, all goes into eu-west-1 & us-east-1

module "global-vpc" {
  source       = "./modules/global-vpc"
  project_name = "global-playground"
}

module "buckets-replicated" {
  source           = "./modules/global-s3-buckets"
  s3_first_bucket  = "global-playground-first-region"
  s3_second_bucket = "global-playground-second-region"
}

module "dynamodb-global-table" {
  source = "./modules/global-table-dynamodb"
}

module "aurora-globalDB" {
  source            = "./modules/global-db-aurora"
  first_db_subnets  = "${module.global-vpc.first_db_subnets}"
  second_db_subnets = "${module.global-vpc.second_db_subnets}"
}

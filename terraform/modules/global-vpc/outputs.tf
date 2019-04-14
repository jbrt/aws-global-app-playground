output "first_vpc_id" {
  value = "${module.first-vpc.vpc_id}"
}

output "first_db_subnets" {
  value = "${module.first-vpc.database_subnets}"
}

output "second_vpc_id" {
  value = "${module.second-vpc.vpc_id}"
}

output "second_db_subnets" {
  value = "${module.second-vpc.database_subnets}"
}
output "db_password" {
  value = "${random_string.password.result}"
}

output "filler_arn" {
  value = "${aws_lambda_function.dynamodb_filler.arn}"
}

output "filler_invoke_arn" {
  value = "${aws_lambda_function.dynamodb_filler.invoke_arn}"
}

output "getter_arn" {
  value = "${aws_lambda_function.dynamodb_getter.arn}"
}

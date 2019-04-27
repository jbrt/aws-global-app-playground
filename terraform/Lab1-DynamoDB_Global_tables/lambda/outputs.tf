output "filler_name" {
  value = "${aws_lambda_function.dynamodb_filler.function_name}"
}

output "filler_invoke_arn" {
  value = "${aws_lambda_function.dynamodb_filler.invoke_arn}"
}

output "getter_name" {
  value = "${aws_lambda_function.dynamodb_getter.function_name}"
}

output "getter_invoke_arn" {
  value = "${aws_lambda_function.dynamodb_getter.invoke_arn}"
}

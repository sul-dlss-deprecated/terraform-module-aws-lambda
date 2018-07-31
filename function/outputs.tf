output arn {
  value = "${aws_lambda_function.lambda_function.arn}"
}

output id {
  value = "${aws_lambda_function.lambda_function.id}"
}

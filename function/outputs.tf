output arn {
  value = "${aws_lambda_function.lambda_function.arn}"
}

output id {
  value = "${aws_lambda_function.lambda_function.id}"
}

output name {
  value = "${aws_lambda_function.lambda_function.name}"
}

output invoke_arn {
  value = "${aws_lambda_function.lambda_function.invoke_arn}"
}

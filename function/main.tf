resource "aws_lambda_function" "test_lambda" {
  handler       = "${var.handler}"
  function_name = "${var.function_name}"
  role          = "${var.execution_role_arn}"
  runtime       = "${var.runtime}"
  s3_bucket     = "${var.s3_bucket}"
  s3_key        = "${var.function_name}/lambda.zip"

  vpc_config {
    subnet_ids         = "${var.subnet_ids}"
    security_group_ids = ["${var.security_group_ids}"]
  }
}

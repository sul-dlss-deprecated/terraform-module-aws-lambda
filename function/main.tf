data "aws_s3_bucket_object" "lambda" {
  bucket = "${var.s3_bucket}"
  key    = "${var.function_name}-${var.environment}/lambda.zip"

  tags {
    terraform = "true"
    project   = "${var.project}"
  }
}

resource "aws_lambda_function" "lambda_function" {
  handler                        = "${var.handler}"
  function_name                  = "${var.function_name}-${var.environment}"
  memory_size                    = "${var.memory_size}"
  role                           = "${var.execution_role_arn}"
  runtime                        = "${var.runtime}"
  s3_bucket                      = "${data.aws_s3_bucket_object.lambda.bucket}"
  s3_key                         = "${data.aws_s3_bucket_object.lambda.key}"
  source_code_hash               = "${base64sha256("${data.aws_s3_bucket_object.lambda.last_modified}")}"
  timeout                        = "${var.timeout}"
  reserved_concurrent_executions = "${var.reserved_concurrent_executions}"

  vpc_config {
    subnet_ids         = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
  }

  environment {
    variables = "${var.lambda_env_vars}"
  }

  dead_letter_config {
    target_arn = "{$var.dead_letter_queue}"
  }

  tags {
    terraform = "true"
    project   = "${var.project}"
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "${var.statement_id}"
  action        = "lambda:InvokeFunction"
  function_name = "${var.function_arn}"
  principal     = "${var.principal}"
  source_arn    = "${var.source_arn}"
}

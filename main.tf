variable "environment" {}

/*====
Lambda execution role
======*/
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.environment}-lambda-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

output "execution_role_arn" {
  value = "${aws_iam_role.lambda_execution_role.arn}"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.function_name}-role-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy" "LambdaExecution" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy" "APIGatewayInvoke" {
  arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  role       = "${aws_iam_role.lambda_execution_role.name}"
  policy_arn = "${data.aws_iam_policy.LambdaExecution.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda_apigateway_policy" {
  role       = "${aws_iam_role.lambda_execution_role.name}"
  policy_arn = "${data.aws_iam_policy.APIGatewayInvoke.arn}"
}

module "lambda_function" {
  source = "github.com/sul-dlss-labs/terraform-aws-lambda/function"

  environment        = "${var.environment}"
  function_name      = "${var.function_name}"
  handler            = "${var.handler}"
  runtime            = "${var.runtime}"
  execution_role_arn = "${aws_iam_role.lambda_execution_role.arn}"           // "arn:aws:iam::418214828013:role/rialto-lambda-role-development"                      // "${aws_iam_role.rialto_lambda_role.arn}"
  s3_bucket          = "${var.project_name}-lambdas-west-${var.environment}"
  subnet_ids         = "${var.subnet_ids}"                                   // ["subnet-01480ce1079abf928", "subnet-0c1d29d602831e4ec", "subnet-0cc143f3b95c85c82"] // "${module.vpc-us-west-2.private_subnets}"
  security_group_ids = "${var.security_group_ids}"

  lambda_env_vars = {
    // RIALTO_SNS_ENDPOINT    = "https://sns.${var.default_region}.amazonaws.com"  // RIALTO_SPARQL_ENDPOINT = "${var.neptune_endpoint}"  // RIALTO_TOPIC_ARN       = "${module.rialto_sns_topic.sns_topic_arn}"
  }
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "${var.function_name}-${var.environment}"
  description = "Terraform generated API Gateway Lambda integration for ${var.function_name}."

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "rest_api_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.rest_api.root_resource_id}"
  path_part   = "${module.lambda_function.name}"
}

resource "aws_api_gateway_method" "rest_api_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id   = "${aws_api_gateway_resource.rest_api_resource.id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
}

resource "aws_api_gateway_integration" "rest_api_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id             = "${aws_api_gateway_resource.rest_api_resource.id}"
  http_method             = "${var.http_method}"
  type                    = "${var.type}"
  uri                     = "${module.lambda_function.invoke_arn}"
  integration_http_method = "${var.integration_method}"
  passthrough_behavior    = "${var.passthrough_behavior}"

  request_templates = {
    "application/x-www-form-urlencoded" = "{\n  \"body\" : $input.json('$')\n}\n"
  }
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id = "${aws_api_gateway_resource.rest_api_resource.id}"
  http_method = "${var.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "200" {
  rest_api_id       = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id       = "${aws_api_gateway_resource.rest_api_resource.id}"
  http_method       = "${var.http_method}"
  status_code       = "200"
  selection_pattern = ""

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = "${module.rialto_sparql_loader_rest_api.id}"
  stage_name  = "${var.environment}"

  depends_on = [
    "aws_api_gateway_method.rest_api_method",
    "aws_api_gateway_integration.rest_api_integration",
  ]
}

// BOOKMARK
module "rialto_sparql_load_lambda_permission" {
  source        = "github.com/sul-dlss-labs/terraform-aws-lambda/permission"
  function_arn  = "${module.rialto_sparql_loader.arn}"
  execution_arn = "${aws_api_gateway_deployment.rest_api_deployment.execution_arn}"
}

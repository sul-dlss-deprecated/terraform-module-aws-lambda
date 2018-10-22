resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "${var.function_name}-${var.environment}"
  description = "Terraform generated API Gateway Lambda integration for ${var.function_name}."
  api_key_source = "${var.api_key_source}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "rest_api_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.rest_api.root_resource_id}"
  path_part   = "${var.function_name}"
}

resource "aws_api_gateway_method" "rest_api_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id   = "${aws_api_gateway_resource.rest_api_resource.id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
  api_key_required     = "true"
}

resource "aws_api_gateway_integration" "rest_api_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id             = "${aws_api_gateway_resource.rest_api_resource.id}"
  http_method             = "${var.http_method}"
  type                    = "${var.type}"
  uri                     = "${var.lambda_url}"
  integration_http_method = "${var.integration_method}"
  passthrough_behavior    = "${var.passthrough_behavior}"
  content_handling        = "${var.content_handling}"
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

resource "aws_api_gateway_method_response" "400" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id = "${aws_api_gateway_resource.rest_api_resource.id}"
  http_method = "${var.http_method}"
  status_code = "400"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "422" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id = "${aws_api_gateway_resource.rest_api_resource.id}"
  http_method = "${var.http_method}"
  status_code = "422"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  stage_name  = "${var.environment}"

  depends_on = [
    "aws_api_gateway_method.rest_api_method",
    "aws_api_gateway_integration.rest_api_integration",
  ]
}

// Usage plans are required for API keys to work. For now, we won't set any quota
// or throttling limits.
resource "aws_api_gateway_usage_plan" "api_usage_plan" {
  name         = "${var.function_name}-${var.environment}-usage-plan"
  description  = "Usage plan (required in order to use API keys)"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.rest_api.id}"
    stage  = "${var.environment}"
  }

  depends_on = ["aws_api_gateway_deployment.rest_api_deployment"]
}

resource "aws_api_gateway_api_key" "api_key" {
  name = "${var.function_name}-${var.environment}-api-key"
}

resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
  key_id        = "${aws_api_gateway_api_key.api_key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.rialto_sparql_loader_usage_plan.id}"
}
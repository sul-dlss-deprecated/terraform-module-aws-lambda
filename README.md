# terraform-aws-lambda

This terraform module is used when creating lambda functions as part of an AWS deployed infrastructure.

## Input Variables

The following input variables are **required** for a lambda function and do not have any default values.

| Variable | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| handler | string | The name of the executable, For Go, this is usually "main" ||
| function_name | string | The function name of the lamba. **Note**: do not include the environment in the function_name, it will be appended automatically. ||
| memory_size | string | Amount of memory to allocate to the lambda | 1024 |
| environment | string | The environment being deployed to (prod/stage/dev) ||
| execution_role_arn | string | The ARN of the execution run for this lambda||
| runtime | string | For Go, this is currently "go1.x" ||
| s3_bucket | string | The S3 location for your projects lambdas, must be in the same region ||
| subnet_ids | list | The list of subnets this lambda will have access to. |
| security_group_ids | string | The list of security groups (for networking rules) related to this lambda |
| timeout | string | The length of execution (in seconds) before returning a timeout error ||
| lambda_env_vars | map | The environment variables for the lambda - can not be empty ||

## Usage

### Create a lambda function

```
// Create Lambda functions
module "demo_lambda" {
  source = "github.com/sul-dlss-labs/terraform-module-aws-lambda//function?ref=v1"

  environment        = "${var.environment}"
  function_name      = "${var.demo_project_name}-demo-lambda"
  handler            = "main"
  memory_size        = "1024"
  runtime            = "go1.x"
  execution_role_arn = "${aws_iam_role.demo_lambda_role.arn}"
  s3_bucket          = "${var.demo_project_name}-lambdas-${var.environment}"
  subnet_ids         = ["${split(",", module.vpc-us-west-2.private_subnets)}"]
  security_group_ids = ["${aws_security_group.demo_lambda_sg.id}"]
  timeout            = "300"

  lambda_env_vars = {
    STATUS    = "${var.environment}"
  }
}
```

### Integrate lambda into API Gateway

```
// Create API Gateway integrations
module "demo_rest_api" {
  source = "github.com/sul-dlss-labs/terraform-module-aws-lambda//integration//apigateway?ref=v1"

  environment          = "${var.environment}"
  function_name        = "${var.demo_project_name}-demo-lambda"
  lambda_url           = "${module.demo_lambda.invoke_arn}"
  function_arn         = "${module.demo_lambda.arn}"
  api_key_source       = "HEADER"
}
```
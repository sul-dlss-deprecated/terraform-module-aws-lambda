# terraform-aws-lambda

This terraform module is used when creating lambda functions as part of an AWS deployed infrastructure.

## Input Variables

The following input variables are **required** for a lambda function and do not have any default values.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| environment | string | The environment being deployed to (prod/stage/dev) |
| execution_role_arn | string | The ARN of the execution run for this lambda|
| function_name | string | The function name of the lamba. **Note**: do not include the environment in the function_name, it will be appended automatically. |
| handler | string | For Go, this is usually "main" |
| runtime | string | For Go, this is currently "go1.x" |
| s3_bucket | string | The S3 location for your projects lambdas |
| subnet_ids | list | The list of subnets this lambda will have access to. |
| security_group_ids | string | The list of security groups (for networking rules) related to this lambda |
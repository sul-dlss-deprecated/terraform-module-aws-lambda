variable "environment" {}
variable "execution_role_arn" {}
variable "function_name" {}
variable "handler" {}
variable "runtime" {}
variable "s3_bucket" {}

variable subnet_ids {
  type = "list"
}

variable security_group_ids {}

variable "lambda_env_vars" {
  type = "map"
}

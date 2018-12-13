variable "environment" {}
variable "project" {}
variable "execution_role_arn" {}
variable "function_name" {}
variable "handler" {}
variable "runtime" {}
variable "s3_bucket" {}
variable "timeout" {}

variable subnet_ids {
  type = "list"
}

variable security_group_ids {
  type = "list"
}

variable "lambda_env_vars" {
  type = "map"
}

variable memory_size {
  default = "1024"
}

variable reserved_concurrent_executions {
  default = 0
}

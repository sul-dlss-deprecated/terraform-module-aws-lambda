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

variable http_method {
  default = "HTTP"
}

variable authorization {
  default = "NONE"
}

variable type {
  default = "AWS"
} # Valid values are: "AWS", "AWS_PROXY", "HTTP", "HTTP_PROXY", or "MOCK"

variable integration_method {
  default = "POST"
}

variable passthrough_behavior {
  default = "WHEN_NO_TEMPLATES"
}

variable request_templates {}

variable project_name {}

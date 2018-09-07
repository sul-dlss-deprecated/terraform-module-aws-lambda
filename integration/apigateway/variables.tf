variable "environment" {}

variable "function_name" {}

variable "function_arn" {}

variable http_method {
  default = "HTTP"
}

variable authorization {
  default = "NONE"
}

variable type {
  default = "AWS_PROXY"
} # Valid values are: "AWS", "AWS_PROXY", "HTTP", "HTTP_PROXY", or "MOCK"

variable integration_method {
  default = "POST"
}

variable passthrough_behavior {
  default = "WHEN_NO_MATCH"
}

variable content_handling {
  default = "CONVERT_TO_TEXT"
}
variable request_templates {}

variable project_name {}

variable api_key_source {
  default = "HEADER"
}

variable lambda_url {}

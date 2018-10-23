output "id" {
  value = "${aws_api_gateway_rest_api.rest_api.id}"
}

output execution_arn {
  value = "${aws_api_gateway_deployment.rest_api_deployment.execution_arn}"
} 

output "api_key" {
  value = "${aws_api_gateway_api_key.api_key.value}"
}

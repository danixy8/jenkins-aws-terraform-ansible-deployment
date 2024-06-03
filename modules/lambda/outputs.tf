output "api_gateway_invoke_url" {
  description = "The base URL to invoke the API Gateway deployment"
  value = aws_api_gateway_deployment.example.invoke_url
}

output "api_gateway_start_instance" {
  description = "The URL to invoke the API Gateway endpoint to start an EC2 instance"
  value = "${aws_api_gateway_deployment.example.invoke_url}${aws_api_gateway_resource.example.path}?action=start"
}

output "api_gateway_stop_instance" {
  description = "The URL to invoke the API Gateway endpoint to stop an EC2 instance"
  value = "${aws_api_gateway_deployment.example.invoke_url}${aws_api_gateway_resource.example.path}?action=stop"
}

output "api_gateway_status_instance" {
  description = "The URL to invoke the API Gateway endpoint to check the status of an EC2 instance"
  value = "${aws_api_gateway_deployment.example.invoke_url}${aws_api_gateway_resource.example.path}?action=status"
}

variable "instance_id" {
  description = "The ID of the EC2 instance"
  type        = string
}

variable "region" {
  description = "AWS region for the provider"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "Account ID"
  type        = string
}

variable "password" {
  description = "Password to execute the lambda"
  type        = string
}



provider "aws" {
  region = var.region
}

module "ec2" {
  source = "./modules/ec2"
  
  project_name            = var.project_name
  instance_type           = var.instance_type
  key_name                = var.key_name
  amazon_linux_host_count = var.amazon_linux_host_count
  private_key_location    = var.private_key_location
  sg_ports                = var.sg_ports 

}

module "lambda" {
  source      = "./modules/lambda"
  
  depends_on = [module.ec2]

  instance_id = module.ec2.ec2_instance_ids[0]
  region      = var.region
  account_id  = var.account_id
  password    = var.password

  providers = {
  aws = aws
  }
}

output "api_gateway_urls" {
  description = "API Gateway URLs for various actions"
  value = <<-EOT
    Invoke URL: ${module.lambda.api_gateway_invoke_url}
    Start Instance URL: ${module.lambda.api_gateway_start_instance}
    Stop Instance URL: ${module.lambda.api_gateway_stop_instance}
    Status Instance URL: ${module.lambda.api_gateway_status_instance}
  EOT
}
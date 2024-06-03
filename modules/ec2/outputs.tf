output "amazon_linux_host_public_ip" {
  description = "public ip's of amazon_linux_host"
  value       = aws_instance.amazon_linux_host[*].public_ip
}

output "amazon_linux_host_private_ip" {
  description = "private ip's of amazon_linux_host"
  value       = aws_instance.amazon_linux_host[*].private_ip
}

output "ec2_instance_ids" {
  description = "The IDs of the created EC2 instances"
  value       = aws_instance.amazon_linux_host[*].id
}

# output "ubuntu_host_public_ip" {
#   description = "public ip's of ubuntu_host"
#   value       = aws_instance.ubuntu_host[*].public_ip
# }

# output "ubuntu_host_private_ip" {
#   description = "private ip's of ubuntu_host"
#   value       = aws_instance.ubuntu_host[*].private_ip
# }
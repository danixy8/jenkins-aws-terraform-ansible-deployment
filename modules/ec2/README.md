### Use the `terraform.tfvars` file to set variables as per your needs

```
project_name            = "spin-up-jenkins-server"
instance_type           = "t2.micro"
key_name                = "jenkins_access"
amazon_linux_host_count = 1
private_key_location    = "/home/ec2-user/.ssh/jenkins_access.pem"
sg_ports = [
  {
    "port" : 22,
    "protocol" : "tcp"
  },
  {
    "port" : -1,
    "protocol" : "icmp"
  },
  {
    "port" : 443,
    "protocol" : "tcp"
  },
  {
    "port" : 80,
    "protocol" : "tcp"
  },
  {
    "port" : 8080,
    "protocol" : "tcp"
  }
]

```

### Run following commands to deploy Instances on aws
```
# set aws credentials on aws cli
aws configure 

# Initilize the terraform
terraform init

# Check before deploy
terraform plan

# Deploy on aws
terraform apply --auto-approve
```
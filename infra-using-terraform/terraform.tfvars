project_name            = "jenkins-server"
instance_type           = "t3.large"
key_name                = "terraform_jenkins_"
amazon_linux_host_count = 1
private_key_location    = "/Users/danielgutierrez/Documents/jenkins/pem_aws_ec2/terraform_jenkins.pem"
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


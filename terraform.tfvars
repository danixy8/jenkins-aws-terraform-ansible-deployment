project_name            = "jenkins-server"
instance_type           = "t2.micro"
key_name                = "terraform_jenkins_"
amazon_linux_host_count = 1
private_key_location    = ""
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

region = "us-east-1"
account_id = ""
password = ""
provider "aws" {
  region  = "us-east-1"
  version = "~> 1.0"
}

resource "aws_instance" "old_server" {
  ami           = "ami-0e9999fakelegacy"
  instance_type = "t2.micro"
  user_data     = <<-EOF
    #!/bin/bash
    yum install -y php-5.4 mysql
  EOF
}

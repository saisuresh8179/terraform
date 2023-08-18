terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-03f65b8614a860c29"
  instance_type = "t2.micro"
  key_name	= "thrid-key-aug-2023"

  tags = {
    Name = "ubuntu"
  }
}
output "public_ipv4_address" {
   value = aws_instance.ec2_instance.public_ip
}

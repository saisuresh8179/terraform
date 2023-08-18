terraform {

  required_providers {
	aws = {
	   source = "hashicorp/aws"
	   version = "~> 4.16"
	}
      }
  required_version = ">= 1.2.0"
}

provider "aws" {
	region = "us-east-2"
}

resource "aws_default_vpc" "default_vpc" {

	tags = {
	    Name = "default vpc"
	}
}

data "aws_availability_zones" "available_zones" {}

resource "aws_default_subnet" "default_subnet" {
  availability_zone = data.aws_availability_zones.available_zones.names[1]
 
  tags = {
     name = "default subnet"
   }
}

resource "aws_security_group" "security_group" {
   name = "ec2_security_group"
   description = "allow access on port 80 and 22"
   vpc_id = aws_default_vpc.default_vpc.id
   
   ingress {
	description = "http acess"
	from_port   = 80
	to_port     = 80
	protocol    = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
     }
    ingress {
	description = "ssh access"
	from_port   = 22
	to_port	    = 22
	protocol    = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
     }
  
    egress {
	from_port   = 0
	to_port     = 0
	protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
     }


     tags = {
         Name = "ec2 security group"
      }
}


resource "aws_instance" "instance" {
	ami 			= "ami-0ccabb5f82d4c9af5"
	instance_type		= "t2.micro"
	subnet_id		= aws_default_subnet.default_subnet.id
	vpc_security_group_ids	= [aws_security_group.security_group.id]
	key_name		= "second-key-aug-2023"
	
 	tags = {
	  Name = "amazon-linux-os"
	}
}

output "public_ipv4_address" {
    value = aws_instance.instance.public_ip
}

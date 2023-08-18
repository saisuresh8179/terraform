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
  region  = "us-east-2"
}

data "aws_instance" "existing_instance" {
	instance_id = "<enter your instance id>"
}
resource "aws_ebs_volume" "volume" {

availability_zone = data.aws_instance.existing_instance.availability_zone

size = 10

 tags = {
 	
	Name = "amazon_linux_volume"
  }
}

resource "aws_volume_attachment" "ebsattach_to_linux" {

	device_name	= "/dev/sdh"
	volume_id	= aws_ebs_volume.volume.id
	instance_id	= data.aws_instance.existing_instance.id
}


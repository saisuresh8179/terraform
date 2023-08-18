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
  region  = "us-east-1"
}


resource "aws_iam_user" "my_user" {
  name = "cloud_enginner"
}

resource "aws_iam_user_login_profile" "example" {
  user    = aws_iam_user.my_user.name
  #pgp_key = "keybase:saisuresh"
  password_reset_required = true
}
resource "aws_iam_access_key" "my_user_key" {
  user = aws_iam_user.my_user.name
}

resource "aws_iam_user_policy_attachment" "my_user_policy_attachment" {
  user       = aws_iam_user.my_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"  # Example policy ARN, replace with your desired policy ARN
 
}
resource "local_file" "output_file" {
  filename = "secret_key.txt"
  content  = aws_iam_access_key.my_user_key.secret
}

resource "local_file" "password" {
   filename = "password.txt"
   content  = aws_iam_user_login_profile.example.password
}
output "Access_key_id" {
  value = aws_iam_access_key.my_user_key.id
}

output "Secret_access_key" {
	value = aws_iam_access_key.my_user_key.secret 
        sensitive = true
}

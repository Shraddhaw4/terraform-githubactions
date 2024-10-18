terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


data "aws_iam_role" "glue-role"{
  name = "glue-demo-role"
}

resource "aws_iam_role" "test-role" {
  name = "Test-Role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}


resource "aws_iam_policy_attachment" "pt" {
  name = aws_iam_role.test-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  roles = [ aws_iam_role.test-role.name ]
}

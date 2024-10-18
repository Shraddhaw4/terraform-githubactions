terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                   = "ap-south-1"
}



data "aws_iam_role" "glue-role"{
  name = "glue-demo-role"
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "terraformstatefiles-1"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}


data "aws_iam_role" "glue-role"{
  name = "glue-demo-role"
}

data "aws_s3_bucket" "pyspark-data" {
  bucket = "shraddha-pyspark-data"
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

# resource "aws_s3_bucket" "pyspark-data" {
#   bucket = "shraddha-pyspark-data"
# }

# resource "aws_s3_object" "folder_cust" {
#   bucket = aws_s3_bucket.pyspark-data.id
#   key    = "customers/customers.csv"
#   source = "pyspark-glue-tutorial-main/customers/customers.csv"
# }

# resource "aws_s3_object" "folder_emp" {
#   bucket = aws_s3_bucket.pyspark-data.id
#   key    = "employees/employees.csv"
#   source = "pyspark-glue-tutorial-main/employees/employees.csv"
# }

# resource "aws_s3_object" "folder_orders" {
#   bucket = aws_s3_bucket.pyspark-data.id
#   key    = "orders/orders.csv"
#   source = "pyspark-glue-tutorial-main/orders/orders.csv"
# }

resource "aws_glue_catalog_database" "pyspark_db" {
  name        = "pyspark_tutorial_db"
  description = "This database contains the tables for the PySpark tutorial"
}

resource "aws_glue_crawler" "cust-crawler" {
  database_name = aws_glue_catalog_database.pyspark_db.name
  name          = "custcrawler"
  role          = data.aws_iam_role.glue-role.arn

  s3_target {
    path = "s3://${data.aws_s3_bucket.pyspark-data.bucket}/customers/"
  }
}

resource "aws_glue_crawler" "order-crawler" {
  database_name = aws_glue_catalog_database.pyspark_db.name
  name          = "ordercrawler"
  role          = data.aws_iam_role.glue-role.arn

  s3_target {
    path = "s3://${data.aws_s3_bucket.pyspark-data.bucket}/orders/"
  }
}

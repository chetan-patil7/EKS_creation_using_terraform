provider "aws" {
  region = "us-east-1"

}

resource "aws_s3_bucket" "s3_demo" {
  bucket = "s3-demo-eks-1234567890"

  tags = {
	"Name" = "s3-demo"
	Environment = "Dev"
  }

  lifecycle {
	prevent_destroy = false
  }

}

resource "aws_dynamodb_table" "dynamo_tf_table" {
  name           = "tf-eks-table2"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "dynamo-id"

  attribute {
	name = "dynamo-id"
	type = "S"
  }
  tags = {
	Name = "dynamo-tf-table"
  }

}

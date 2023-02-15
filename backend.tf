terraform {
  backend "s3" {
    bucket = "myiacbacket"
    key    = "terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "iac_table"

  }
}

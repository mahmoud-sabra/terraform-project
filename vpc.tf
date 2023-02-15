resource "aws_vpc" "myiacvpc" {

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    "name" = "myiacvpc"
  }
}

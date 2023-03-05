variable "region" {
  default = "string"
}


variable "vpc_cidr" {
  default = "string"
}

variable "enable_dns_hostnames" {
  default = "string"
}

variable "preferred_number_of_public_subnets" {
  default = null
}
variable "preferred_number_of_private_subnets" {
  default = null
}
variable "preferred_number_of_elastic_ip" {
  default = null
}
variable "preferred_number_of_natgw"{
  default = null
}
variable "preferred_number_of_private_subnets_association" {
  default = null
}
variable "public_route_table_cidr" {
  default = "string"

}

variable "ip_address_type" {
  default = "string"
}
variable "load_balancer_type" {
  default = "string"
}
variable "ami" {
  default = "string"

}
variable "keypair" {
  default = "string"

}
variable "account_no" {
  default = "string"
}
variable "master-username" {
  default = "string"
}
variable "master-password" {
  default = "string"
}

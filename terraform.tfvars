region = "us-east-1"

vpc_cidr = "10.0.0.0/16"

enable_dns_hostnames = "true"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

public_route_table_cidr = "0.0.0.0/0"

ip_address_type = "ipv4"

load_balancer_type = "application"
ami                = "ami-0aa7d40eeae50c9a9"
keypair            = "sabra"
# account_no          = "615441546724"
master-username = "sabra"
master-password = "sabra"
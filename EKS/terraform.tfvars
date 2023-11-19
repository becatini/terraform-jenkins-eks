# Grab the variable name for vpc and subnet on variables.tf and use here as variable name
vpc_cidr = "10.90.0.0/24"

public_subnets = ["10.90.0.0/28", "10.90.0.16/28", "10.90.0.32/28"]

private_subnets = ["10.90.0.48/28", "10.90.0.64/28", "10.90.0.80/28"]
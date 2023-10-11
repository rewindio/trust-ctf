variable "aws_region" {
  description = "The region to deploy into (defaults to 'ca-central-1' for legal reasons)"
  type        = string

  default = "ca-central-1"
}

variable "vpc_cidr_block" {
  description = "The IPv4 CIDR block for the CTF VPC"
  type        = string

  default = "192.168.42.0/24"
}

variable "subnet_natgw_cidr_block" {
  description = "The IPv4 CIDR block for the NAT Gateway subnet"
  type        = string

  default = "192.168.42.0/26"
}

variable "subnet_owaspjs_cidr_block" {
  description = "The IPv4 CIDR block for the OWASP Juice Shop subnet"
  type        = string

  default = "192.168.42.64/26"
}

variable "subnet_cftd_cidr_block" {
  description = "The IPv4 CIDR block for the CFTd subnet"
  type        = string

  default = "192.168.42.128/26"
}

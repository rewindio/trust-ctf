variable "aws_region" {
  description = "The region to deploy into (defaults to 'ca-central-1' for legal reasons)"
  type        = string

  default = "ca-central-1"
}

variable "aws_availability_zone_a" {
  description = "The availability zone to deploy into (defaults to 'ca-central-1a' for legal reasons)"
  type        = string

  default = "ca-central-1a"
}

variable "aws_availability_zone_b" {
  description = "The availability zone to deploy into (defaults to 'ca-central-1b' for legal reasons)"
  type        = string

  default = "ca-central-1b"
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

variable "subnet_a_rds_cidr_block" {
  description = "The IPv4 CIDR block for the RDS subnet A"
  type        = string

  default = "192.168.42.192/28"

}

variable "subnet_b_rds_cidr_block" {
  description = "The IPv4 CIDR block for the RDS subnet B"
  type        = string

  default = "192.168.42.208/28"

}

variable "instance_type" {
  description = "The instance type to use for the CTFd and OWASP Juice Shop EC2 instances"
  type        = string

  default = "t2.micro"
}

variable "db_password" {
  description = "RDS user password"
  type        = string
  sensitive   = true
}

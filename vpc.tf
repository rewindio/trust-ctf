###======================== CTF VPC ====================== ###

resource "aws_vpc" "ctf" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "CTF (${var.aws_region})"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ctf.id

  tags = {
    Name = "CTF | Internet Gateway"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw_eip.id
  subnet_id     = aws_subnet.natgw.id

  tags = {
    Name = "CTF | NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw, aws_eip.natgw_eip]
}

resource "aws_eip" "natgw_eip" {
  domain           = "vpc"
  public_ipv4_pool = "amazon"

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "ctf" {
  vpc_id = aws_vpc.ctf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "CTF IGW | Subnet Routing Table"
  }
}

resource "aws_route_table" "ctf_natgw" {
  vpc_id = aws_vpc.ctf.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "CTF NAT GW | Subnet Routing Table"
  }
}

resource "aws_subnet" "natgw" {
  vpc_id     = aws_vpc.ctf.id
  cidr_block = var.subnet_natgw_cidr_block

  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "NAT Gateway | Subnet"
  }
}

resource "aws_subnet" "ctfd" {
  vpc_id     = aws_vpc.ctf.id
  cidr_block = var.subnet_cftd_cidr_block

  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "CFPd | Subnet"
  }
}

resource "aws_subnet" "owaspjs" {
  vpc_id     = aws_vpc.ctf.id
  cidr_block = var.subnet_owaspjs_cidr_block

  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "OWASP Juice Shop | Subnet"
  }
}

resource "aws_route_table_association" "natgw" {
  subnet_id      = aws_subnet.natgw.id
  route_table_id = aws_route_table.ctf.id
}

resource "aws_route_table_association" "ctfd" {
  subnet_id      = aws_subnet.ctfd.id
  route_table_id = aws_route_table.ctf_natgw.id
}

resource "aws_route_table_association" "owaspjs" {
  subnet_id      = aws_subnet.owaspjs.id
  route_table_id = aws_route_table.ctf_natgw.id
}

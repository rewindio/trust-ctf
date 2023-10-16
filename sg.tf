###======================== CTF Security Groups ====================== ###

resource "aws_default_security_group" "ctf" {
  vpc_id = aws_vpc.ctf.id

  # Default Deny All Traffic in VPC default SG
}

resource "aws_security_group" "ctf" {
  #checkov:skip=CKV_AWS_260:Ensure no security groups allow ingress from 0.0.0.0:0 to port 80

  name        = "CTF Default Security Group"
  description = "CTF Default Security Group"
  vpc_id      = aws_vpc.ctf.id

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All Traffic Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-ctf-default"
  }
}

resource "aws_security_group" "rds" {
  name        = "CTF RDS Security Group"
  description = "CTF RDS Security Group"
  vpc_id      = aws_vpc.ctf.id

  ingress {
    description     = "RDS from internal SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ctf.id]
  }

  egress {
    description = "Allow All Traffic Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-ctf-rds"
  }
}

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

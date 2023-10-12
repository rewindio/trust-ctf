data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

###======================== CTFd EC2 ====================== ###

resource "aws_instance" "ctfd" {
  #checkov:skip=CKV_AWS_8:Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted
  #checkov:skip=CKV_AWS_88:EC2 instance should not have public IP
  #checkov:skip=CKV_AWS_126:Ensure that detailed monitoring is enabled for EC2 instances
  #checkov:skip=CKV_AWS_135:Ensure that EC2 is EBS optimized

  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.ctfd.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.ctf.id
  ]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size = 40
  }

  iam_instance_profile = aws_iam_instance_profile.ctf.id

  tags = {
    Name = "CTFd"
  }
}

###================= OWASP Juice Shop EC2 ================= ###

resource "aws_instance" "owaspjs" {
  #checkov:skip=CKV_AWS_8:Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted
  #checkov:skip=CKV_AWS_88:EC2 instance should not have public IP
  #checkov:skip=CKV_AWS_126:Ensure that detailed monitoring is enabled for EC2 instances
  #checkov:skip=CKV_AWS_135:Ensure that EC2 is EBS optimized

  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.owaspjs.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.ctf.id
  ]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size = 40
  }

  iam_instance_profile = aws_iam_instance_profile.ctf.id

  tags = {
    Name = "OWASP Juice Shop"
  }
}

###======================== CTF DB ====================== ###

resource "aws_kms_key" "rds" {
  description = "CFTd DB KMS key"

  deletion_window_in_days = 7
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = true
  multi_region            = true

  tags = {
    Name = "CFTd KMS Key"
  }
}

resource "aws_db_subnet_group" "cftd" {
  name       = "cftd_db_subnet_group"
  subnet_ids = [aws_subnet.rds_a.id, aws_subnet.rds_b.id]

  tags = {
    Name = "CFTd DB Subnet Group"
  }
}

/*
resource "aws_db_instance" "cftd" {
  identifier             = "ctfd-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mariadb"
  engine_version         = "10.6.14"
  multi_az               = false
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.rds.arn
  username               = "cftd"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.cftd.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}
*/

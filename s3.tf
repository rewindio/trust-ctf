###======================== CTF S3 Ansible ====================== ###

# resource "aws_s3_bucket" "ansible" {
#   #checkov:skip=CKV2_AWS_61:Ensure that an S3 bucket has a lifecycle configuration
#   #checkov:skip=CKV_AWS_18:Ensure the S3 bucket has access logging enabled
#   #checkov:skip=CKV2_AWS_65:Ensure access control lists for S3 buckets are disabled
#   #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
#   #checkov:skip=CKV_AWS_145:Ensure that S3 buckets are encrypted with KMS by default
#   #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled

#   bucket = var.ansible_playbook_bucket_name
# }

# resource "aws_s3_bucket_versioning" "ansible" {
#   bucket = aws_s3_bucket.ansible.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "ansible" {
#   bucket = aws_s3_bucket.ansible.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# resource "aws_s3_bucket_ownership_controls" "ansible" {
#   bucket = aws_s3_bucket.ansible.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "ansible" {
#   depends_on = [aws_s3_bucket_ownership_controls.ansible]

#   bucket = aws_s3_bucket.ansible.id
#   acl    = "private"
# }

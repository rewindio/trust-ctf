###======================== CTF S3 Ansible ====================== ###

resource "aws_s3_bucket" "ansible" {
  bucket = var.ansible_playbook_bucket_name
}

resource "aws_s3_bucket_versioning" "ansible" {
  bucket = aws_s3_bucket.ansible.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ansible" {
  bucket = aws_s3_bucket.ansible.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "ansible" {
  bucket = aws_s3_bucket.ansible.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_acl" "ansible" {
  depends_on = [aws_s3_bucket_ownership_controls.ansible]

  bucket = aws_s3_bucket.ansible.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow_access_from_ssm" {
  bucket = aws_s3_bucket.ansible.id
  policy = data.aws_iam_policy_document.allow_access_from_ssm.json
}

data "aws_iam_policy_document" "allow_access_from_ssm" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_instance_profile.ctf.role}"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.ansible.arn,
      "${aws_s3_bucket.ansible.arn}/*",
    ]
  }
}

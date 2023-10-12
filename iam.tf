resource "aws_iam_instance_profile" "ctf" {
  name = "ctf_ec2_instance_profile"
  role = aws_iam_role.ctf_role.name
}

data "aws_iam_policy_document" "ctf_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ctf_role" {
  name = "ctf_ec2_role"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.ctf_assume_role.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

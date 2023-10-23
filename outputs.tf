output "ctf_private_dns" {
  description = "The private DNS name of the CTFd EC2 instance"
  value       = aws_instance.ctfd.private_dns
}

output "owaspjs_private_dns" {
  description = "The private DNS name of the OWASP Juice Shop EC2 instance"
  value       = aws_instance.owaspjs.private_dns
}

output "s3_bucket_name_ansible_playbooks" {
  description = "The Ansible playbook S3 bucket name"
  value       = aws_s3_bucket.ansible.bucket
}

output "ec2_cftd_instance_id" {
  description = "The EC2 instance ID of the CTFd instance"
  value       = aws_instance.ctfd.id
}

output "ec2_owaspjs_instance_id" {
  description = "The EC2 instance ID of the OWASP Juice Shop instance"
  value       = aws_instance.owaspjs.id
}

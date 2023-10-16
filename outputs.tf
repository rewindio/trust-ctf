output "ctf_private_dns" {
  description = "The private DNS name of the CTFd EC2 instance"
  value       = aws_instance.ctfd.private_dns
}

output "owaspjs_private_dns" {
  description = "The private DNS name of the OWASP Juice Shop EC2 instance"
  value       = aws_instance.owaspjs.private_dns
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.cftd.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.cftd.port
}

output "rds_username" {
  description = "RDS instance username"
  value       = aws_db_instance.cftd.username
}

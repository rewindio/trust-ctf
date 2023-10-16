output "ctf_public_ip" {
  description = "The public IP address of the CTFd EC2 instance"
  value       = aws_instance.ctfd.public_ip
}

output "ctf_public_dns" {
  description = "The public DNS name of the CTFd EC2 instance"
  value       = aws_instance.ctfd.public_dns
}

output "owaspjs_public_ip" {
  description = "The public IP address of the OWASP Juice Shop EC2 instance"
  value       = aws_instance.owaspjs.public_ip
}

output "owaspjs_public_dns" {
  description = "The public DNS name of the OWASP Juice Shop EC2 instance"
  value       = aws_instance.owaspjs.public_dns
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

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

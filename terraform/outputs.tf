output "public_web_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.public_web.public_ip
}

output "public_instance_id" {
  description = "Instance ID of the public web server"
  value       = aws_instance.public_web.id
}

output "private_instance_id" {
  description = "Instance ID of the private admin server"
  value       = aws_instance.private_admin.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}
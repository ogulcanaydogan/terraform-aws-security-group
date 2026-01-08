output "id" {
  description = "ID of the security group."
  value       = aws_security_group.this.id
}

output "arn" {
  description = "ARN of the security group."
  value       = aws_security_group.this.arn
}

output "name" {
  description = "Name of the security group."
  value       = aws_security_group.this.name
}

output "vpc_id" {
  description = "VPC ID where the security group was created."
  value       = aws_security_group.this.vpc_id
}

output "owner_id" {
  description = "Owner ID (AWS account ID) of the security group."
  value       = aws_security_group.this.owner_id
}

output "sg_id" {
  description = "security group id to associate with the EC2 instance"
  value       = aws_security_group.tf_sg_allow_http.id

}
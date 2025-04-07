output "vpc_id" {
  value = aws_vpc.tf_vpc.id
}

output "subnet_id" {
  value = aws_subnet.tf_public_subnet.id
}
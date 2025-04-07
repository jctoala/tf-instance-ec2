variable "subnet_id" {
  description = "List of subnet IDs to deploy the EC2 instance in"
  type        = string

}

variable "sg_id" {
  description = "security group ID to associate with the EC2 instance"
  type        = string

}
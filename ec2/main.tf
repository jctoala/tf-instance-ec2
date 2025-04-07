
resource "aws_instance" "tf_ec2_instance" {
  ami                         = "ami-0a9a48ce4458e384e" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true
  user_data                   = file("./ec2/user_data.sh") # script to install apache and start the service

  tags = {
    Name = "tf-ec2-instance"
  }
}
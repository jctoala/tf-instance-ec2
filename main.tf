resource "aws_resourcegroups_group" "name" {
  name = "tf-rgoup"
  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]
      TagFilters = [
        {
          Key    = "Environment"
          Values = ["dev"]
        }
      ]
    })
  }
}

resource "aws_vpc" "tf_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-vpc"
  }
}

resource "aws_subnet" "tf_public_subnet" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "172.16.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-public-subnet"
  }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf-igw"
  }
}

resource "aws_route_table" "tf_rt_publica" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "tf-rt-publica"
  }
}

resource "aws_route_table_association" "tf_rta_publica" {
  subnet_id      = aws_subnet.tf_public_subnet.id
  route_table_id = aws_route_table.tf_rt_publica.id
}

resource "aws_security_group" "tf_sg_allow_http" {
  name        = "tf-sg-allow-http"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf-sg-allow-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tf_sg_allow_http_rule" {
  security_group_id = aws_security_group.tf_sg_allow_http.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "tf_sg_allow_all" {
  security_group_id = aws_security_group.tf_sg_allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "tf_ec2_instance" {
  ami                         = "ami-0a9a48ce4458e384e" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.tf_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.tf_sg_allow_http.id]
  associate_public_ip_address = true
  user_data                   = file("user_data.sh") # script to install apache and start the service

  tags = {
    Name = "tf-ec2-instance"
  }
}
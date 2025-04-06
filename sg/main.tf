
resource "aws_security_group" "tf_sg_allow_http" {
  name        = "tf-sg-allow-http"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

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
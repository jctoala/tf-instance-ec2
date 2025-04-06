
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

resource "aws_vpc" "main-vpc" {
  cidr_block       = "10.12.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main-vpc.id
}

resource "aws_route_table" "rtb-pri" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "rtb-pub" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "subnet-a" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "10.12.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-a.id
  route_table_id = aws_route_table.rtb-pub.id
}

resource "aws_subnet" "subnet-b" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "10.12.2.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet-b.id
  route_table_id = aws_route_table.rtb-pri.id
}

resource "aws_subnet" "subnet-c" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "10.12.3.0/24"
  availability_zone = "us-west-2c"
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.subnet-c.id
  route_table_id = aws_route_table.rtb-pri.id
}

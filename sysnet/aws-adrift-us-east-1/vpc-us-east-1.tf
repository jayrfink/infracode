resource "aws_vpc" "vpc-adrift" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_support = "true"                                                   
  enable_dns_hostnames = "true"

  tags = {
    Name = "vpc-adrift"
  }
}

resource "aws_internet_gateway" "igw-vpc-adrift" {
 vpc_id = "${aws_vpc.vpc-adrift.id}"

 tags = {
    Name = "igw-vpc-adrift"
 }
}

resource "aws_subnet" "net-adrift-w" {
  vpc_id = "${aws_vpc.vpc-adrift.id}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"
  cidr_block        = "10.0.1.0/28"
  tags = {
    Name = "net-adrift-w-use1b"
  }
}

resource "aws_subnet" "net-adrift-p" {
  vpc_id = "${aws_vpc.vpc-adrift.id}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"
  cidr_block        = "10.0.100.0/28"
  tags = {
    Name = "net-adrift-p-use1b"
  }
}

resource "aws_eip" "vpc-adrift-nat" {
  vpc = true
}

resource "aws_nat_gateway" "natgw-vpc-adrift-w" {
  allocation_id = "${aws_eip.vpc-adrift-nat.id}"
  subnet_id     = "${aws_subnet.net-adrift-w.id}"

  tags = {
    Name = "natgw-vpc-adrift-w"
  }
}

resource "aws_security_group" "adrift-sg-egress" {
  name        = "sg-egress"
  description = "sg-egress"
  vpc_id = "${aws_vpc.vpc-adrift.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "adrift-sg-egress"
  }
}

resource "aws_security_group" "adrift-sg-ssh" {
  name        = "sg-ssh"
  description = "SSH"
  vpc_id = "${aws_vpc.vpc-adrift.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
       "0.0.0.0/0",
      ]
  }

  tags = {
    Name = "adrift-sg-ssh"
  }
}

resource "aws_security_group" "vpc-adrift-https" {
  name        = "vpc-adrift-https"
  description = "https"
  vpc_id = "${aws_vpc.vpc-adrift.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
       "0.0.0.0/0",
      ]
  }

  tags = {
    Name = "vpc-adrift-https"
  }
}

resource "aws_route_table" "rtbl-vpc-adrift-w" {
  vpc_id = "${aws_vpc.vpc-adrift.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-vpc-adrift.id}"
  }

  tags = {
    Name = "rtbl-vpc-adrift-w"
  }
}

resource "aws_route_table" "rtbl-vpc-adrift-p" {
  vpc_id = "${aws_vpc.vpc-adrift.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw-vpc-adrift-w.id}"
  }

  tags = {
    Name = "rtbl-vpc-adrift-w"
  }
}

resource "aws_route_table_association" "rta-vpc-adrift-w" {
  subnet_id      = aws_subnet.net-adrift-w.id
  route_table_id = aws_route_table.rtbl-vpc-adrift-w.id
}

resource "aws_route_table_association" "rta-vpc-adrift-p" {
  subnet_id      = aws_subnet.net-adrift-p.id
  route_table_id = aws_route_table.rtbl-vpc-adrift-p.id
}


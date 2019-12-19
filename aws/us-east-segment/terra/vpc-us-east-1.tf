resource "aws_vpc" "vpc-segmented" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-segmented"
  }
}

resource "aws_internet_gateway" "igw-vpc-segmented" {
 vpc_id = "${aws_vpc.vpc-segmented.id}"

 tags = {
    Name = "igw-vpc-segmented"
 }
}

resource "aws_subnet" "subnet-vpc-segmented-w" {
  vpc_id = "${aws_vpc.vpc-segmented.id}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"
  cidr_block        = "10.0.1.0/28"
  tags = {
    Name = "subnet-vpc-segmentediw-use1b"
  }
}

resource "aws_subnet" "subnet-vpc-segmented-p" {
  vpc_id = "${aws_vpc.vpc-segmented.id}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"
  cidr_block        = "10.0.100.0/28"
  tags = {
    Name = "subnet-vpc-segmentedp-use1b"
  }
}

resource "aws_eip" "vpc-segmented-natw" {
  vpc = true
}

resource "aws_nat_gateway" "natgw-vpc-segmented-w" {
  allocation_id = "${aws_eip.vpc-segmented-natw.id}"
  subnet_id     = "${aws_subnet.subnet-vpc-segmented-w.id}"

  tags = {
    Name = "natgw-vpc-segmented-w"
  }
}

resource "aws_security_group" "sg-egress" {
  name        = "sg-egress"
  description = "sg-egress"
  vpc_id = "${aws_vpc.vpc-segmented.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-segmented-egress"
  }
}

resource "aws_security_group" "sg-ssh" {
  name        = "sg-ssh"
  description = "SSH"
  vpc_id = "${aws_vpc.vpc-segmented.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
       "0.0.0.0/0",
      ]
  }

  tags = {
    Name = "vpc-segmented-ssh"
  }
}

resource "aws_security_group" "vpc-segmented-https" {
  name        = "vpc-segmented-https"
  description = "https"
  vpc_id = "${aws_vpc.vpc-segmented.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
       "0.0.0.0/0",
      ]
  }

  tags = {
    Name = "vpc-segmented-https"
  }
}

resource "aws_route_table" "rtbl-vpc-segmented-w" {
  vpc_id = "${aws_vpc.vpc-segmented.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-vpc-segmented.id}"
  }

  tags = {
    Name = "rtbl-vpc-segmented-w"
  }
}

resource "aws_route_table" "rtbl-vpc-segmented-p" {
  vpc_id = "${aws_vpc.vpc-segmented.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw-vpc-segmented-w.id}"
  }

  tags = {
    Name = "rtbl-vpc-segmented-w"
  }
}

resource "aws_route_table_association" "rta-vpc-segmented-w" {
  subnet_id      = aws_subnet.subnet-vpc-segmented-w.id
  route_table_id = aws_route_table.rtbl-vpc-segmented-w.id
}

resource "aws_route_table_association" "rta-vpc-segmented-p" {
  subnet_id      = aws_subnet.subnet-vpc-segmented-p.id
  route_table_id = aws_route_table.rtbl-vpc-segmented-p.id
}


resource "aws_vpc" "vpc-outrider-ingress" {
  cidr_block       = "10.253.0.0/19"
  instance_tenancy = "default"

  enable_dns_support = "true"                                                   
  enable_dns_hostnames = "true"

  tags = {
    Name = "vpc-outrider-ingress"
    Desc = "Staging & Testing VPC"
  }
}

resource "aws_internet_gateway" "igw-vpc-outrider-ingress" {
 vpc_id = "${aws_vpc.vpc-outrider-ingress.id}"

 tags = {
    Name = "igw-vpc-outrider-ingress"
 }
}

resource "aws_subnet" "net-outrider-ingress-us-east1a" {
  vpc_id = "${aws_vpc.vpc-outrider-ingress.id}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
  cidr_block        = "10.253.0.0/28"
  tags = {
    Name = "net-outrider-ingress-us-east1a-10-254-32-0_24"
  }
}


resource "aws_security_group" "outrider-access-secgrp-egress" {
  name        = "outrider-access-secgrp-egress"
  description = "Egress"
  vpc_id = "${aws_vpc.vpc-outrider-ingress.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "outrider-access-secgrp-egress"
  }
}

resource "aws_security_group" "outrider-access-secgrp-ssh" {
  name        = "outrider-access-secgrp-ssh"
  description = "SSH"
  vpc_id = "${aws_vpc.vpc-outrider-ingress.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
       "0.0.0.0/0",
      ]
  }

  tags = {
    Name = "outrider-access-secgrp-ssh"
  }
}

resource "aws_route_table" "rtbl-vpc-outrider-ingress-us-east1a" {
  vpc_id = "${aws_vpc.vpc-outrider-ingress.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-vpc-outrider-ingress.id}"
  }

  tags = {
    Name = "rtbl-vpc-outrider-ingress-us-east1a"
  }
}

resource "aws_route_table_association" "rta-vpc-outrider-ingress-us-east1a" {
  subnet_id      = aws_subnet.net-outrider-ingress-us-east1a.id
  route_table_id = aws_route_table.rtbl-vpc-outrider-ingress-us-east1a.id
}


resource "aws_vpc" "vpc-outrider-core" {
  cidr_block       = "10.254.0.0/19"
  instance_tenancy = "default"

  enable_dns_support = "true"                                                   
  enable_dns_hostnames = "true"

  tags = {
    Name = "vpc-outrider-core"
    Desc = "Core Routing VPC, routes between vpcs and out to internet."
  }
}

resource "aws_internet_gateway" "igw-vpc-outrider-core" {
 vpc_id = "${aws_vpc.vpc-outrider-core.id}"

 tags = {
    Name = "igw-vpc-outrider-core"
 }
}

resource "aws_subnet" "net-outrider-core-tegr-us-east1a" {
  vpc_id = "${aws_vpc.vpc-outrider-core.id}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"
  cidr_block        = "10.254.0.0/28"
  tags = {
    Name = "net-outrider-core-tegr-us-east1a-10-254-0-0_28"
  }
}

resource "aws_subnet" "net-outrider-core-natgw-us-east1a" {
  vpc_id = "${aws_vpc.vpc-outrider-core.id}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
  cidr_block        = "10.254.0.48/28"
  tags = {
    Name = "net-outrider-core-natgw-us-east1a-10-254-0-48_28"
  }
}

resource "aws_security_group" "outrider-core-secgrp-egress" {
  name        = "outrider-core-secgrp-egress"
  description = "Egress"
  vpc_id = "${aws_vpc.vpc-outrider-core.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "outrider-core-secgrp-egress"
  }
}

resource "aws_security_group" "outrider-core-secgrp-ssh" {
  name        = "outrider-core-secgrp-ssh"
  description = "SSH"
  vpc_id = "${aws_vpc.vpc-outrider-core.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
       "0.0.0.0/0",
      ]
  }

  tags = {
    Name = "outrider-core-secgrp-ssh"
  }
}

resource "aws_security_group" "outrider-core-secgrp-https" {
  name        = "outrider-core-secgrp-https"
  description = "https"
  vpc_id = "${aws_vpc.vpc-outrider-core.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
       "0.0.0.0/0",
      ]
  }

  tags = {
    Name = "outrider-core-secgrp-https"
  }
}

resource "aws_eip" "vpc-outrider-core-nat" {
  vpc = true
}

resource "aws_nat_gateway" "natgw-vpc-outrider-core" {
  allocation_id = "${aws_eip.vpc-outrider-core-nat.id}"
  subnet_id     = "${aws_subnet.net-outrider-core-natgw-us-east1a.id}"

  tags = {
    Name = "natgw-vpc-outrider-core"
  }
}


resource "aws_route_table" "rtbl-vpc-outrider-core-tegr-us-east1a" {
  vpc_id = "${aws_vpc.vpc-outrider-core.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw-vpc-outrider-core.id}"
  }

  tags = {
    Name = "rtbl-vpc-outrider-core-tegr-us-east1a"
  }
}

resource "aws_route_table" "rtbl-vpc-outrider-core-natgw-us-east1a" {
  vpc_id = "${aws_vpc.vpc-outrider-core.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-vpc-outrider-core.id}"
  }

  tags = {
    Name = "rtbl-vpc-outrider-core-natgw-us-east1a"
  }
}

resource "aws_route_table_association" "rta-vpc-outrider-core-tegr-us-east1a" {
  subnet_id      = aws_subnet.net-outrider-core-tegr-us-east1a.id
  route_table_id = aws_route_table.rtbl-vpc-outrider-core-tegr-us-east1a.id
}

resource "aws_route_table_association" "rta-vpc-outrider-core-natgw-us-east1a" {
  subnet_id      = aws_subnet.net-outrider-core-natgw-us-east1a.id
  route_table_id = aws_route_table.rtbl-vpc-outrider-core-natgw-us-east1a.id
}


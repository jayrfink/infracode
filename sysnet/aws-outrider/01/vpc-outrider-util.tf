resource "aws_vpc" "vpc-outrider-util" {
  cidr_block       = "10.254.32.0/19"
  instance_tenancy = "default"

  enable_dns_support = "true"                                                   
  enable_dns_hostnames = "true"

  tags = {
    Name = "vpc-outrider-util"
    Desc = "Staging & Testing Utility VPC"
  }
}

resource "aws_internet_gateway" "igw-vpc-outrider-util" {
 vpc_id = "${aws_vpc.vpc-outrider-util.id}"

 tags = {
    Name = "igw-vpc-outrider-util"
 }
}

resource "aws_subnet" "net-outrider-util-us-east1a" {
  vpc_id = "${aws_vpc.vpc-outrider-util.id}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"
  cidr_block        = "10.254.34.0/24"
  tags = {
    Name = "net-outrider-util-us-east1a-10-254-34-0_24"
  }
}


resource "aws_security_group" "outrider-util-secgrp-egress" {
  name        = "outrider-util-secgrp-egress"
  description = "Egress"
  vpc_id = "${aws_vpc.vpc-outrider-util.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "outrider-util-secgrp-egress"
  }
}

resource "aws_security_group" "outrider-util-secgrp-ssh" {
  name        = "outrider-util-secgrp-ssh"
  description = "SSH"
  vpc_id = "${aws_vpc.vpc-outrider-util.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
       "0.0.0.0/0",
      ]
  }

  tags = {
    Name = "outrider-util-secgrp-ssh"
  }
}

resource "aws_security_group" "outrider-util-secgrp-https" {
  name        = "outrider-util-secgrp-https"
  description = "https"
  vpc_id = "${aws_vpc.vpc-outrider-util.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
       "0.0.0.0/0",
      ]
  }

  tags = {
    Name = "outrider-util-secgrp-https"
  }
}


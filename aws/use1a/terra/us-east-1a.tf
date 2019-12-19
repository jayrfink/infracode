provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_subnet" "subnet-use1a-pub" {
  vpc_id            = "VPC_ID"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
  cidr_block        = "10.0.20.0/28"
  tags = {
    Name = "subnet-use1a-pub"
  }
}

resource "aws_subnet" "subnet-use1a-pvt" {
  vpc_id            = "VPC_ID"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"
  cidr_block        = "10.0.30.0/28"
  tags = {
    Name = "subnet-use1a-pvt"
  }
}


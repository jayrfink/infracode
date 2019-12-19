resource "aws_instance" "private-1" {
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ 
	"${aws_security_group.sg-egress.id}",
	"${aws_security_group.sg-ssh.id}",
  ]
  subnet_id = "${aws_subnet.subnet-vpc-segmented-p.id}"
  availability_zone = "us-east-1b"
  key_name = "MY_KEY"
  associate_public_ip_address = "false"
  root_block_device { 
     volume_type = "gp2"
     volume_size = "8"
     encrypted = "true"
    }

  tags = {
    Name = "private-1",
    Owner = "Jason_Fink",
    Type  = "dev",
    Desc = "test Instance"
  }
}

resource "aws_instance" "private-2" {
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ 
	"${aws_security_group.sg-egress.id}",
	"${aws_security_group.sg-ssh.id}",
  ]
  subnet_id = "${aws_subnet.subnet-vpc-segmented-p.id}"
  availability_zone = "us-east-1b"
  key_name = "MY_KEY"
  associate_public_ip_address = "false"
  root_block_device { 
     volume_type = "gp2"
     volume_size = "8"
     encrypted = "true"
    }

  tags = {
    Name = "private-2",
    Owner = "Jason_Fink",
    Type  = "dev",
    Desc = "test Instance"
  }
}

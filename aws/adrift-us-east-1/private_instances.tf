resource "aws_instance" "adrift-private-1" {
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ 
	"${aws_security_group.adrift-sg-egress.id}",
	"${aws_security_group.adrift-sg-ssh.id}",
  ]
  subnet_id = "${aws_subnet.net-adrift-p.id}"
  availability_zone = "us-east-1b"
  key_name = "adrift"
  associate_public_ip_address = "false"
  root_block_device { 
     volume_type = "gp2"
     volume_size = "8"
     encrypted = "true"
    }

  tags = {
    Name = "adrift-private-1",
    Owner = "Jason_Fink",
    Type  = "dev",
    Desc = "test Instance"
  }
}

resource "aws_instance" "adrift-private-2" {
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ 
	"${aws_security_group.adrift-sg-egress.id}",
	"${aws_security_group.adrift-sg-ssh.id}",
  ]
  subnet_id = "${aws_subnet.net-adrift-p.id}"
  availability_zone = "us-east-1b"
  key_name = "adrift"
  associate_public_ip_address = "false"
  root_block_device { 
     volume_type = "gp2"
     volume_size = "8"
     encrypted = "true"
    }

  tags = {
    Name = "adrift-private-2",
    Owner = "Jason_Fink",
    Type  = "dev",
    Desc = "test Instance"
  }
}

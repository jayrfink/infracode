resource "aws_instance" "adrift-bastion" {
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ 
	"${aws_security_group.adrift-secgrp-egress.id}",
	"${aws_security_group.adrift-secgrp-ssh.id}",
  ]
  subnet_id = "${aws_subnet.net-adrift-w.id}"
  availability_zone = "us-east-1b"
  key_name = "MY_KEY"
  associate_public_ip_address = "true"
  root_block_device { 
     volume_type = "gp2"
     volume_size = "16"
     encrypted = "true"
    }

  tags = {
    Name = "bastion",
    Owner = "Jason_Fink",
    Type  = "prod",
    Desc = "SSH Bastion Host"
  }
}


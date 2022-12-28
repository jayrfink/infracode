resource "aws_instance" "outrider-core-natgw1a" {
  ami           = "YOURAMI"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ 
	"${aws_security_group.outrider-core-secgrp-ssh.id}",
	"${aws_security_group.outrider-core-secgrp-egress.id}",
  ]
  subnet_id = "${aws_subnet.net-outrider-core-natgw-us-east1a.id}"
  availability_zone = "us-east-1a"
  key_name = "YOURPEMKEY"
  associate_public_ip_address = "true"
  root_block_device { 
     volume_type = "gp2"
     volume_size = "12"
     encrypted = "true"
    }

  tags = {
    Name = "outrider-core-natgw1a"
    Desc = "SSH HOP VM to test setup."
  }

}

resource "aws_instance" "outrider-util1a" {
  ami           = "YOURAMI"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ 
	"${aws_security_group.outrider-util-secgrp-ssh.id}",
	"${aws_security_group.outrider-util-secgrp-egress.id}",
  ]
  subnet_id = "${aws_subnet.net-outrider-util-us-east1a.id}"
  availability_zone = "us-east-1a"
  key_name = "YOURPEMKEY"
  associate_public_ip_address = "false"
  root_block_device { 
     volume_type = "gp2"
     volume_size = "12"
     encrypted = "true"
    }

  tags = {
    Name = "outrider-util1a"
    Desc = "Testing Instance"
  }

}


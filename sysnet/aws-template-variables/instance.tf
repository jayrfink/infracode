resource "aws_instance" "INSTANCE-LABEL" {
  ami           = "AMI-ID"
  instance_type = "t2.micro" // you probably want to change this...
  vpc_security_group_ids = [
	var.secgrp-adrift-ssh,
	var.secgrp-adrift-egress,
  ]


  subnet_id = var.net-adrift
  availability_zone = var.avail-zone
  key_name = "PEMKEY"
  root_block_device {
     volume_type = "gp2"
     volume_size = "12"
     encrypted = "true"
    }

  tags = {
    Name = "INSTANCE-LABEL"
    Desc = "BRIEF-DESCRIPTION"
  }
}

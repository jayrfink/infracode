resource "aws_instance" "outrider-ingress1a" {
  ami           = "YOURAMI"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ 
	"${aws_security_group.outrider-access-secgrp-ssh.id}",
	"${aws_security_group.outrider-access-secgrp-egress.id}",
  ]
  subnet_id = "${aws_subnet.net-outrider-ingress-us-east1a.id}"
  availability_zone = "us-east-1a"
  key_name = "YOURPEMKEY"
  associate_public_ip_address = "true"
  root_block_device { 
     volume_type = "gp2"
     volume_size = "12"
     encrypted = "true"
    }

  tags = {
    Name = "outrider-ingress1a"
    Desc = "Ingress Bastion VM"
  }

}


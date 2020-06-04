resource "aws_instance" "adrift_node" {
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "r5.16xlarge"
  count = 4
  vpc_security_group_ids = [ 
	"${aws_security_group.adrift-egress.id}",
	"${aws_security_group.adrift-ssh.id}",
  ]
  subnet_id = "${aws_subnet.subnet-adrift-w.id}"
  private_ip = [ "10.1.100.101", "10.1.100.102", "10.1.100.103", "10.1.100.104" ]
  availability_zone = "us-east-1b"
  key_name = "adrift_a"
  associate_public_ip_address = "true"
  root_block_device { 
     volume_type = "gp2"
     volume_size = "16"
     encrypted = "true"
    }

  tags = {
    Name = "adrift-compute",
    Owner = "Jay_Fink",
    Type  = "adrift_node"
    Desc = "Adrift Standard Compute Node"
  }
}

resource "aws_instance" "adrift_gpu" {
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "p3dn.24xlarge"
  count = 2
  vpc_security_group_ids = [ 
	"${aws_security_group.adrift-egress.id}",
	"${aws_security_group.adrift-ssh.id}",
  ]
  subnet_id = "${aws_subnet.subnet-adrift-w.id}"
  private_ip = [ "10.1.100.201", "10.1.100.202" ]
  availability_zone = "us-east-1b"
  key_name = "adrift_a"
  associate_public_ip_address = "true"
  root_block_device { 
     volume_type = "gp2"
     volume_size = "16"
     encrypted = "true"
    }

  tags = {
    Name = "adrift-gpu",
    Owner = "Jay_Fink",
    Type  = "adrift_gpu"
    Desc = "Adrift GPU Node"
  }
}



resource "aws_instance" "$INSTANCE_NAME_TAG" {
  ami           = "$AMI_ID"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "$SECURITY_GROUP", ]
  subnet_id = "$SUBNET_ID"
  availability_zone = "us-east-1a"
  key_name = "$YOUR_PEM_KEY_NAME"
  associate_public_ip_address = "false"
  root_block_device { 
     volume_type = "gp2"
     volume_size = "16"
     encrypted = "true"
    }

  tags = {
    Name = "$INSTANCE_NAME_TAG",
    Owner = "$FIRSTNAME_LASTNAME",
    Type  = "dev",
    Desc = "A meaningful description"
  }
}


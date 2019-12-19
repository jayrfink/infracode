resource "aws_security_group" "aws-ssh-pub" {
  name        = "aws-ssh"
  description = "AWS Internal SSH in default VPC"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ 
       "10.0.10.0/28",
      ]
  }

  tags = {
    Name = "aws-ssh-pub"
  }
}

